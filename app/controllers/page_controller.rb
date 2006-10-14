class PageController < ApplicationController
  scaffold :page
  cache_sweeper :page_sweeper
  caches_page :show, :displaypage

  def comments
    @page = Page.find params[:id]
    render :partial => "comments"
  end

  def displaypage
    space_name = params[:space_name]
    space_name = space_name[1..-1] if space_name[0]==126 # is ~
    space = Space.find :first, :conditions=>[ "name=?", space_name]
    @page = Page.find :first, :conditions=>["title=? and space_id=?", params[:page_title], space.id]
    @comments = @page.comments
    render_scaffold "show"
  end

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
    if params[:type] == 'Weblog'
      @page = Weblog.new
    else 
      @page = Page.new
    end

    @page.title=params[:title] unless params[:title].nil?
    @page.space_id = params[:space_id]
    render_scaffold
  end

  def create
    if params[:page][:type] == 'Weblog'
      @page = Weblog.new( params[:page])
    else 
      @page = Page.new(params[:page]) 
    end
    @page.created_at = @page.updated_at = Time.now
    @page.user_id = current_user.id
    @page.creator_id = current_user.id
    if @page.save
      flash[:notice] = "page was successfully created"
      redirect_to :controller=>'page', :action => "show", :id=>@page.id
    else
      render_scaffold('new')
    end
  end

  def update
    @page = Page.find(params[:id])
    @page.user=current_user
    if @page.update_attributes(params[:page])
      flash[:notice] = 'page was successfully updated.'
      redirect_to :action => 'show', :id => @page
    else
      render :action => 'edit'
    end
  end

  def preview
    @preview_page = Page.new params[:page]
    render :layout=>false
  end

  def feed
    conditions = params[:query].sub(/space/,'space_id') if params[:query]
    conditions = " space_id = #{params[:id]} " if params[:id]
    @pages=Page.find(:all, :conditions=>conditions, :order=> "updated_at DESC", :limit=>15)
    @headers["Content-Type"] = "application/rss+xml"
    render :layout=>false
  end

  def list
    @page_pages, @pages = 
      paginate :pages, :per_page=>10, :conditions=>" space_id = #{params[:id]} ", :order=>"title"
    render_scaffold( 'list')
  end
end
