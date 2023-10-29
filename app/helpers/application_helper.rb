module ApplicationHelper
  
  def friendly_date(time)
    time.strftime('%b %d')
  end

  def friendly_time(time)
    time.strftime('%l:%M%P')
  end

  def friendly_hour(time)
    time.strftime('%I%P')
  end

  def temp(point_detail, **opts)
    temp_key = opts[:mod] ? "temp_#{opts[:mod]}" : "temp"

    "#{point_detail[temp_key.to_sym]}°#{point_detail[:temp_units]}"
  end
end
