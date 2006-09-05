class MainController < ApplicationController
  helper :calendar

  def welcome
    @spaces = Space.find(:all)
    today = Date.today
    @year = params[:year] || today.year
    @month = params[:month] || today.month
    @weblogs = Weblog.find :all, :limit=>20, :order => 'created_at DESC'
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
end
