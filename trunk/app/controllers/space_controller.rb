class SpaceController < ApplicationController
  helper :calendar
  scaffold :space
  caches_page :show, :show_home, :show_month

  # 用 yyyymm*10000+space_id 来做为展示哪个space的哪个月份
  def show_month
    id=params[:id].to_i
    params[:year]=id/1000000
    month=(id-params[:year]*1000000)/10000
    params[:month]=month if month>0
    space_id=id%10000
    params[:id]=space_id if space_id>0
    params[:id]=nil if space_id==0
    #render :action => "show"
    show
  end

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
    @results = Page.find_by_contents(params[:search][:query])
  end

  def show
    SpaceHelper.getDatePeriod params

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
    # 如果没有任何条件，则找前15个weblog
    # 如果指定年、月、日，则找该时间范围内的weblog
    # 如果指定了space，则将范围限制在该space当中
    conditions = " created_at < '#{params[:date_to]+1}' and created_at >= '#{params[:date_from]}' "
    conditions += " and space_id = #{params[:id]} " unless params[:id].nil?
    @weblogs = Weblog.find :all, :conditions=>conditions, :limit=>15, :order => 'created_at DESC'

    # 建立page title 的cache
    # @title_caches = {}

    # updates of all
    conditions = "space_id = #{params[:id]}" unless params[:id].nil?
    @recent_updated=Page.find :all, :limit=>15, :order => 'updated_at DESC', :conditions=>conditions
    @recent_comment_updated=Comment.find :all, :limit=>15, :order=>'created_at DESC'
    @space = Space.find( params[:id]) if params[:id]
    render "space/show"
  end

  def sitemap
    @pages = Page.find :all, :order => 'updated_at DESC'
    @headers["Content-Type"] = "application/xml"
    render :layout=>false
  end
  
  private

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
end
