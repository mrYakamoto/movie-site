module WelcomeHelper
  require 'date'

  def set_start_date(date)
    date - date.wday
  end

  def reset_date_filler(date)
    DateTime.new(date.year, date.month, 1) - date.wday
  end

  def films_today(screenings, date)
    screenings = all_screenings_today(screenings, date)
      films = screenings.map{|sc|sc.film}
      films = films.uniq
  end

  def screenings_today?(screenings, date)

    return true if screenings.detect{|screening|(screening.month == date.month)&&(screening.mday == date.mday)&&(screening.year == date.year)}
    false

  end

  def all_screenings_today(screenings, date)
    screenings.select{|screening|(screening.month == date.month)&&(screening.mday == date.mday)&&(screening.year == date.year)}
  end

  def screenings_today(film, date)
    film.screenings.where("month = ? AND mday = ? AND year = ?",date.month, date.mday, date.year)

  end

end
