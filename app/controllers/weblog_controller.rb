class WeblogController < ApplicationController
  scaffold :weblog

  def show
    @weblog = Weblog.find( params[:id])
    @comments = @weblog.comments
  end

  def comment
    comment = Comment.new( params[:comment])
    comment.user_id = current_user.id
    weblog = Weblog.find( params[:id]).add_comment comment
    redirect_to :action => "show", :id => params[:id]
  end

  def new
    @weblog = Weblog.new
    @weblog.space_id = params[:space_id]
    render_scaffold
  end

  def create
    @weblog = Weblog.new(params[:weblog])
    @weblog.user_id = current_user.id
    if @weblog.save
      flash[:notice] = "Weblog was successfully created"
      redirect_to :action => "list"
    else
      render_scaffold('new')
    end
  end

end
