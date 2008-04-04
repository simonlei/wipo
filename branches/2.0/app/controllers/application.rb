# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  acts_as_anonymous_user :anonymous_user => AnonymousUser
  helper :all # include all helpers, all the time
  
  #helper RbacHelper

  layout "base"
  
  # The application controller will give us the "current_user" method.
  # include ActiveRbacMixins::ApplicationControllerMixin

  before_filter :set_charset 
  before_filter :protect_controller, :except => [ :list, :index, :show, :welcome, :login, :download, :feed, :search, :displaypage, :show_home, :loginbox, :show_month, :comments, :view_count, :sitemap]
  
  def protect_controller 
    if current_user.has_role?("Admin")
      return true
    elsif (current_user.is_anonymous? || (["delete"].include? action_name) || (["static_permission","user","role"].include? controller_name))
      redirect_to "/active_rbac/login/login?return_to=#{request.request_uri}"
      flash[:notice] = "You are not allowed to access this page" 
      return false 
    else
      return true
    end 
  end

  def set_charset 
    if request.xhr? 
      headers["Content-Type"] = "text/javascript; charset=utf-8" 
    else 
      headers["Content-Type"] = "text/html; charset=utf-8" 
    end 
  end 
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '6fb7f310333b8c2240f66478fd01a236'
end
