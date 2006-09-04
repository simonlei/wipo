module MainHelper
  def date_title( blog, prev_date)
    return "" if prev_date == blog.log_date
    return "<div class=\"DateTitle\"> #{blog.log_date.to_s}</div>"
  end
end
