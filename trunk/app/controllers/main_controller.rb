class MainController < ApplicationController
  helper :calendar

  def block (d)
  end 

  def welcome
    @spaces = Space.find(:all)
    @year = params[:year] || 2006
    @month = params[:month] || 9
    @weblogs = Page.find :all, :limit=>20, :order => 'created_at'
  end
end
