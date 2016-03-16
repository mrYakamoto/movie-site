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
