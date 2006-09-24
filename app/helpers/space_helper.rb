module SpaceHelper

  def can_have_action
    true 
  end

  def date_title( blog, prev_date)
    return "" if prev_date == blog.log_date
    return "<div class=\"DateTitle\"> #{blog.log_date.to_s}</div>"
  end

  def SpaceHelper::getDatePeriod params
    @today = Date.today
    date_from = date_to = @today
    if params[:year] # ָ�������
      year = params[:year].to_i
      if params[:month] # ָ�����·�
        month = params[:month].to_i
        if params[:day] # ָ��������
          day = params[:day].to_i
          date_from = date_to = Date.new(year,month,day)
        else # δָ�����ڣ������·�ȫ��ȡ��
          date_from = Date.new year, month
          date_to = Date.new year, month, -1
        end
      else # δָ���·ݣ��������ȫ��ȡ��
        date_from = Date.new year
        date_to = Date.new year, -1, -1
      end
    else # δָ����ݣ���������
      date_from = Date.new 0, 1, 1
    end

    params[:date_from] = date_from
    params[:date_to] = date_to
    params[:year] = date_to.year
    params[:month] = date_to.month
    params[:day] = date_to.day
  end
end
