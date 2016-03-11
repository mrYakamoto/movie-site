module CalendarHelper
  require 'date'

  def nums_for_calendar_month
    # today_obj = DateTime.new(2016,03,5)
    today_obj = DateTime.new(2016,3,5)
    if ((today_obj.wday <= 6)&&(today_obj.mday <= 7))
      p 'IFFFFFF'
      calendar_nums = filler_days(today_obj)
    end

    calendar_nums ||= []

    (1..days_this_month(today_obj)).each do |n|
      calendar_nums << n
    end
    return calendar_nums
  end

  def filler_days(today_obj)
    prev_month_days = num_days_last_month(today_obj)
    first_filler_date = ( prev_month_days - ( today_obj.wday - 1 ))
    Array(first_filler_date..prev_month_days)
  end

  def days_this_month(today_obj)
    Date.civil(today_obj.year,today_obj.month,-1).mday
  end

  def num_days_last_month(today_obj)
    prev_month = today_obj.prev_month
    return Date.civil(prev_month.year,prev_month.month,-1).mday
  end

end







