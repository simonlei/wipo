class SpaceController < ApplicationController

  def show
    @space = Space.find( params[:id])
  end
end
