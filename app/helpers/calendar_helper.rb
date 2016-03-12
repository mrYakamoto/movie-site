module CalendarHelper
  require 'date'

  def nums_for_calendar_month
    # today_obj = DateTime.new(2016,03,5)
    today_obj = DateTime.now()
    month_starts_on = DateTime.new(today_obj.year, today_obj.month, 1).wday
    if (month_starts_on != 0)
      calendar_nums = filler_days(today_obj)
    end

    calendar_nums ||= []

    (1..days_this_month(today_obj)).each do |n|
      calendar_nums << n
    end
    return calendar_nums
  end

  def filler_days(today_obj)
    prev_month_str = Date::MONTHNAMES[today_obj.prev_month.month].downcase

    prev_month_days = num_days_last_month(today_obj)
    first_filler_date = ( prev_month_days - ( today_obj.wday - 1 ))
    dates_from_last_month = Array(first_filler_date..prev_month_days)
    dates_from_last_month.map!{|date|Array[date,prev_month_str]}
  end

  def days_this_month(today_obj)
    Date.civil(today_obj.year,today_obj.month,-1).mday
  end

  def num_days_last_month(today_obj)
    prev_month = today_obj.prev_month
    return Date.civil(prev_month.year,prev_month.month,-1).mday
  end

end







