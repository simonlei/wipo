class UserController < ApplicationController
  layout nil

  def loginbox
    if current_user.is_anonymous?
      render :partial => "anonymous"
    else
      render :partial => "loggined"
    end
  end

  def view_count
    if params[:a] != 'show'
      return render :text=>""
    end
    if params[:id].nil?
      object_type = 'Main' 
    else
      object_type = params[:c].capitalize
    end
    conditions=" object_type='#{object_type}' "
    conditions += " and object_id=#{params[:id]} " unless params[:id].nil?
    view_count = ViewCount.find :first, :conditions=> conditions
    if view_count == nil
      view_count = ViewCount.new
      view_count.count = 0
      view_count.object_type = object_type
      view_count.object_id = params[:id] unless params[:id].nil?
    end

    view_count.count += 1
    view_count.save
    render :text=>"本页面已被访问#{view_count.count.to_s}次。"
  end
end
