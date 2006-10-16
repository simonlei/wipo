# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require_dependency "#{RAILS_ROOT}/vendor/plugins/active_rbac/app/helpers/rbac_helper"

class ApplicationController < ActionController::Base
  helper RbacHelper

  layout "base"
  
  # The application controller will give us the "current_user" method.
  include ActiveRbacMixins::ApplicationControllerMixin

  before_filter :set_charset 
  before_filter :protect_controller, :except => [ :list, :index, :show, :welcome, :login, :download, :feed, :search, :displaypage, :show_home, :loginbox, :show_month, :comments, :view_count]
  
  def protect_controller 
    if current_user.has_role?("Admin")
      return true
    elsif (current_user.is_anonymous? || (["delete"].include? action_name) || (["static_permission","user","role"].include? controller_name))
      puts action_name.class
      redirect_to "/active_rbac/login/login?return_to=#{request.request_uri}"
      flash[:notice] = "You are not allowed to access this page" 
      return false 
    else
      return true
    end 
  end

  def set_charset 
    if request.xhr? 
      @headers["Content-Type"] = "text/javascript; charset=utf-8" 
    else 
      @headers["Content-Type"] = "text/html; charset=utf-8" 
    end 
  end

end
