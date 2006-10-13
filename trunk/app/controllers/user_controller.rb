class UserController < ApplicationController
  layout nil

  def loginbox
    if current_user.is_anonymous?
      render :partial => "anonymous"
    else
      render :partial => "loggined"
    end
  end
end
