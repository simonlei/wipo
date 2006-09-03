class SpaceController < ApplicationController
  scaffold :space

  def show
    @space = Space.find( params[:id])
  end
end
