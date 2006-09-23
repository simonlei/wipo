class SpaceController < ApplicationController
  helper :calendar
  scaffold :space

  def welcome
    @spaces = Space.find(:all)
    today = Date.today
    @year = params[:year] || today.year
    @month = params[:month] || today.month
    @weblogs = Page.find :all, :limit=>20, :order => 'created_at DESC'
    @weblogs_by_day = sort_weblogs_by_day( @weblogs)
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

    @spaces = Space.find(:all)
    @year = params[:year] 
    @month = params[:month] 
    # weblogs in the month
    first_day_in_month = Date.new @year, @month, 1
    last_day_in_month = Date.new @year, @month, -1
    conditions = " created_at <= '#{last_day_in_month}' and created_at >= '#{first_day_in_month}' "
    conditions += " and space_id= #{params[:id]} " unless params[:id].nil?
    weblogs_in_the_month = Weblog.find :all, :conditions=>conditions
    @weblogs_by_day = sort_weblogs_by_day( weblogs_in_the_month)

    # weblogs of top 20
    # 如果没有任何条件，则找前20个weblog
    # 如果指定年、月、日，则找该时间范围内的weblog
    # 如果指定了space，则将范围限制在该space当中
    conditions = " created_at <= '#{params[:date_to]}' and created_at >= '#{params[:date_from]}' "
    conditions += " and space_id = #{params[:id]} " unless params[:id].nil?
    @weblogs = Weblog.find :all, :conditions=>conditions, :limit=>20, :order => 'created_at DESC'

    # updates of all
    conditions = "space_id = #{params[:id]}" unless params[:id].nil?
    @recent_updated=Page.find :all, :limit=>20, :order => 'updated_at DESC', :conditions=>conditions
    #@space = Space.find( params[:id])
  end
end
