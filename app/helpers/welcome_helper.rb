module WelcomeHelper

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
