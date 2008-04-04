module SpacesHelper
  def can_have_action
    true 
  end

  def date_title( blog, prev_date)
    return "" if prev_date == blog.log_date
    return "<div class=\"DateTitle\"> #{blog.log_date.to_s}</div>"
  end

  def SpacesHelper::get_date_period params
    @today = Date.today
    date_from = date_to = @today
    if params[:year] # 指定了年份
      year = params[:year].to_i
      if params[:month] # 指定了月份
        month = params[:month].to_i
        if params[:day] # 指定了日期
          day = params[:day].to_i
          date_from = date_to = Date.new(year,month,day)
        else # 未指定日期，整个月份全部取出
          date_from = Date.new year, month
          date_to = Date.new year, month, -1
        end
      else # 未指定月份，整个年份全部取出
        date_from = Date.new year
        date_to = Date.new year, -1, -1
      end
    else # 未指定年份，不限条件
      date_from = Date.new 0, 1, 1
    end

    params[:date_from] = date_from
    params[:date_to] = date_to
    params[:year] = date_to.year
    params[:month] = date_to.month
    params[:day] = date_to.day
  end
end
