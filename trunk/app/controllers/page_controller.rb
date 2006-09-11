class PageController < ApplicationController
  scaffold :page

  def show
    @page = Page.find( params[:id])
    @comments = @page.comments
  end

  def comment
    comment = Comment.new( params[:comment])
    comment.user_id = current_user.id
    page = Page.find( params[:id]).add_comment comment
    redirect_to :action => "show", :id => params[:id]
  end

  def new
    @page = Page.new
    @page.space_id = params[:space_id]
    render_scaffold
  end

  def create
    @page = Page.new(params[:page])
    @page.user_id = current_user.id
    if @page.save
      flash[:notice] = "page was successfully created"
      redirect_to :action => "list"
    else
      render_scaffold('new')
    end
  end

end
