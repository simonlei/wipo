# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include WikiHelper

  def url_for_user user
    if user.personal_space_id > 0
      link_to user.login, :controller=>"space", :action=>"show", :id => user.personal_space_id
    else
      user.login 
    end
  end

  def time_to_str time
    time.strftime "%Y 年 %m 月 %d 日 %H:%M" unless time.nil?
  end
end
