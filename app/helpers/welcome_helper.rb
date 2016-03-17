module WelcomeHelper
  require 'date'

  def set_start_date(date)
    date - date.wday
  end

  def reset_date_filler(date)
    DateTime.new(date.year, date.month, 1) - date.wday
  end

  def films_today?(date)
    return true if Screening.find_by("month = ? AND mday = ? AND year = ?",date.month, date.mday, date.year)
    false
  end

  def films_today(date)
    screenings = Screening.where("month = ? AND mday = ? AND year = ?",date.month, date.mday, date.year)
    films = []
    screenings.each do |screening|
      films << screening.film unless films.include?(screening.film)
    end
    films
  end

  def screenings_today(film, date)
    film.screenings.where("month = ? AND mday = ? AND year = ?",date.month, date.mday, date.year)
  end

  def theater_name(film, date)
    Screening.find_by("month = ? AND mday = ? AND year = ?",date.month, date.mday, date.year).theater.name
  end

end
