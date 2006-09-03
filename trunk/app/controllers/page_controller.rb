class PageController < ApplicationController
  scaffold :page

  def show
    @page = Page.find( params[:id])
  end

  def new
    @page = Page.new
    @page.space_id = params[:space_id]
#    @page.space = Space.find( params[:space_id])
    render_scaffold
  end

  def create
    @page = Page.new(params[:page])
#    @page.space_id = params[:space_id]
    if @page.save
      flash[:notice] = "Page was successfully created"
      redirect_to :action => "list"
    else
      render_scaffold('new')
    end
  end

end
