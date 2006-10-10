class SpaceController < ApplicationController
  helper :calendar
  scaffold :space

  def show_home
    page = Page.find :first, :conditions=>["title=? and space_id=?", "Home", params[:id]]
    if page.nil? then
      redirect_to :controller=>'space', :action=>'show', :id=>params[:id]
    else
      # The space has page titled "Home", then use it
      redirect_to :controller=>'page', :action=>'show', :id=>page
    end
  end

  def search
    query = params[:search][:query]
    @results = Page.find_by_contents(query)
  end

  def sort_weblogs_by_day( weblogs)
    weblogs_by_day = {}
    weblogs.each do |weblog|
      blogs_in_day = weblogs_by_day[ weblog.log_date]
      blogs_in_day = [] if blogs_in_day.nil?
      blogs_in_day << weblog
      weblogs_by_day[ weblog.log_date] = blogs_in_day
    end
    return weblogs_by_day
  end

  def show
    SpaceHelper.getDatePeriod params

    # sum the view count
    get_view_count

    @spaces = Space.find(:all)
    @year = params[:year] 
    @month = params[:month] 
    # weblogs in the month
    first_day_in_month = Date.new @year, @month, 1
    last_day_in_month = Date.new @year, @month, -1
    conditions = " created_at < '#{last_day_in_month+1}' and created_at >= '#{first_day_in_month}' "
    conditions += " and space_id= #{params[:id]} " unless params[:id].nil?
    weblogs_in_the_month = Weblog.find :all, :conditions=>conditions
    @weblogs_by_day = sort_weblogs_by_day( weblogs_in_the_month)

    # weblogs of top 15
    # ���û���κ�����������ǰ15��weblog
    # ���ָ���ꡢ�¡��գ����Ҹ�ʱ�䷶Χ�ڵ�weblog
    # ���ָ����space���򽫷�Χ�����ڸ�space����
    conditions = " created_at < '#{params[:date_to]+1}' and created_at >= '#{params[:date_from]}' "
    conditions += " and space_id = #{params[:id]} " unless params[:id].nil?
    @weblogs = Weblog.find :all, :conditions=>conditions, :limit=>15, :order => 'created_at DESC'

    # ����page title ��cache
    # @title_caches = {}

    # updates of all
    conditions = "space_id = #{params[:id]}" unless params[:id].nil?
    @recent_updated=Page.find :all, :limit=>15, :order => 'updated_at DESC', :conditions=>conditions
    @space = Space.find( params[:id]) if params[:id]
  end
  
  private

  def get_view_count
    if params[:id]
      @view_count = ViewCount.find :first, :conditions=> " object_type='Space' and object_id=#{params[:id]} " 
    else
      @view_count = ViewCount.find :first, :conditions=> " object_type='Main' " 
    end
    if @view_count == nil
      @view_count = ViewCount.new
      @view_count.count = 0
      if params[:id] == nil
        @view_count.object_type = 'Main'
      else
        @view_count.object_type = 'Space'
        @view_count.object_id = params[:id]
      end
    end

    @view_count.count += 1
    @view_count.save
  end

end
