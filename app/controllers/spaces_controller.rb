class SpacesController < ApplicationController
  # GET /spaces
  # GET /spaces.xml
  def index
    @spaces = Space.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @spaces }
    end
  end

  # GET /spaces/1
  # GET /spaces/1.xml
  def show2
    @space = Space.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @space }
    end
  end

  # GET /spaces/new
  # GET /spaces/new.xml
  def new
    @space = Space.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @space }
    end
  end

  # GET /spaces/1/edit
  def edit
    @space = Space.find(params[:id])
  end

  # POST /spaces
  # POST /spaces.xml
  def create
    @space = Space.new(params[:space])

    respond_to do |format|
      if @space.save
        flash[:notice] = 'Space was successfully created.'
        format.html { redirect_to(@space) }
        format.xml  { render :xml => @space, :status => :created, :location => @space }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @space.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /spaces/1
  # PUT /spaces/1.xml
  def update
    @space = Space.find(params[:id])

    respond_to do |format|
      if @space.update_attributes(params[:space])
        flash[:notice] = 'Space was successfully updated.'
        format.html { redirect_to(@space) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @space.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /spaces/1
  # DELETE /spaces/1.xml
  def destroy
    @space = Space.find(params[:id])
    @space.destroy

    respond_to do |format|
      format.html { redirect_to(spaces_url) }
      format.xml  { head :ok }
    end
  end
  
  helper :calendar
  #scaffold :space
  caches_page :show, :show_home, :show_month

  # 用 yyyymm*10000+space_id 来做为展示哪个space的哪个月份
  def show_month
    if !(params[:id].nil?)
      id=params[:id].to_i
      params[:year]=id/1000000
      month=(id-params[:year]*1000000)/10000
      params[:month]=month if month>0
      space_id=id%10000
      params[:id]=space_id if space_id>0
      params[:id]=nil if space_id==0
    end
    show
  end

  def show_home
    page = Page.find :first, :conditions=>["title=? and space_id=?", "Home", params[:id]]
    if page.nil? then
      redirect_to :controller=>'space', :action=>'show', :id=>params[:id]
    else
      # The space has page titled "Home", then use it
      redirect_to :controller=>'page', :action=>'show', :id=>page
    end
  end

  def search
    @results = Page.find_by_contents(params[:search][:query])
  end

  def show
    SpacesHelper.get_date_period params

    @spaces = Space.find(:all)
    @year = params[:year] 
    @month = params[:month] 
    # weblogs in the month
    first_day_in_month = Date.new @year, @month, 1
    last_day_in_month = Date.new @year, @month, -1
    conditions = " created_at < '#{last_day_in_month+1}' and created_at >= '#{first_day_in_month}' "
    conditions += " and space_id= #{params[:id]} " unless params[:id].nil?
    weblogs_in_the_month = Weblog.find :all, :conditions=>conditions
    @weblogs_by_day = sort_weblogs_by_day( weblogs_in_the_month)

    # weblogs of top 15
    # 如果没有任何条件，则找前15个weblog
    # 如果指定年、月、日，则找该时间范围内的weblog
    # 如果指定了space，则将范围限制在该space当中
    conditions = " created_at < '#{params[:date_to]+1}' and created_at >= '#{params[:date_from]}' "
    conditions += " and space_id = #{params[:id]} " unless params[:id].nil?
    @weblogs = Weblog.find :all, :conditions=>conditions, :limit=>15, :order => 'created_at DESC'

    # 建立page title 的cache
    # @title_caches = {}

    # updates of all
    conditions = "space_id = #{params[:id]}" unless params[:id].nil?
    @recent_updated=Page.find :all, :limit=>15, :order => 'updated_at DESC', :conditions=>conditions
    @recent_comment_updated=Comment.find :all, :limit=>15, :order=>'created_at DESC'
    @space = Space.find( params[:id]) if params[:id]
    render :template => "spaces/show"
  end

  def sitemap
    @pages = Page.find :all, :order => 'updated_at DESC'
    headers["Content-Type"] = "application/xml"
    render :layout=>false
  end
  
  private

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
