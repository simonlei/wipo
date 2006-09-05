# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require_dependency "#{RAILS_ROOT}/vendor/plugins/active_rbac/app/helpers/rbac_helper"

class ApplicationController < ActionController::Base
  helper RbacHelper

  layout "base"
  
  # The application controller will give us the "current_user" method.
  include ActiveRbacMixins::ApplicationControllerMixin

  before_filter :protect_controller, :except => [ :list, :index, :show, :welcome, :login]
  
  def protect_controller 
    if current_user.has_role?("Admin")
      return true
    else 
      redirect_to "/main/welcome"
      flash[:notice] = "You are not allowed to access this page" 
      return false 
    end 
  end

end
