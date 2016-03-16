module WelcomeHelper
  require 'date'


  # pseudo for refactoring
  # send all screening objects for a month, grouped by day, to the view
  # send today's DateTime object to the view

  # if today's wday is != 0, fill in the filler dates
    # helper method
  # for each date after those, get all screening objects and display their info


  def set_start_date(date)
    date - date.wday
  end

  def films_today(date)
    Screening.where("date_time(year) = ?",2016)
  end



  def increment_date
  end

  def nums_for_calendar_month
    # today_obj = DateTime.new(2016,03,5)
    today_obj = DateTime.now()
    month_starts_on_wday = DateTime.new(today_obj.year, today_obj.month, 1).wday
    if ((today_obj.mday <= 6)&&(month_starts_on_wday != 0))
      calendar_nums = prev_month_filler_days(today_obj, month_starts_on_wday)
    end

    calendar_nums ||= []

    if (today_obj.wday != 0)
      first_day = today_obj.mday - today_obj.wday
    else
      first_day = today_obj.mday
    end

    (first_day..days_this_month(today_obj)).each do |n|
      calendar_nums << n
    end
    return calendar_nums
  end



  def prev_month_filler_days(today_obj, month_starts_on_wday)
    prev_month_str = Date::MONTHNAMES[today_obj.prev_month.month].downcase
    prev_month_days = num_days_last_month(today_obj)
    first_filler_date = ( prev_month_days - ( month_starts_on_wday - 1 ))
    dates_from_last_month = Array(first_filler_date..prev_month_days)
    dates_from_last_month.map!{|date|Array["-#{date}-",prev_month_str]}
  end

  def days_this_month(today_obj)
    Date.civil(today_obj.year,today_obj.month,-1).mday
  end

  def num_days_last_month(today_obj)
    prev_month = today_obj.prev_month
    return Date.civil(prev_month.year,prev_month.month,-1).mday
  end






  def from_past_month?(date)
    date.class == Array ? true : false
  end

  def get_past_month_string(date)
    "#{date.pop()} #{date[0]}"
  end

  def reformat_array_to_string(date)
    date[0].to_s
  end

  def handle_past_month_info(slice)
    if from_past_month?(slice[0])
      string = get_past_month_string(slice[0])
      slice[0] = reformat_array_to_string(slice[0])
      return string
    else
      false
    end
  end

end
