class MainController < ApplicationController

  def welcome
    @spaces = Space.find(:all)
  end
end
