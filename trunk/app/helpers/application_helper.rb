# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include WikiHelper

  def time_to_str time
    time.strftime "%YÄê%mÔÂ%dÈÕ%H:%M" unless time.nil?
  end
end
