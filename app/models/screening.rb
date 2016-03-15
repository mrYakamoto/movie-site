class Screening < ActiveRecord::Base
  belongs_to :theater
  belongs_to :film

  def self.full_month_screenings(month)
    screenings_arr = Screening.all.where(month: month)
    screenings_hash = {}

    screenings_arr.each do |screening_obj|
      showtime_html = "<a href='#{screening_obj.ticketing_url}''><span class='showtime'>#{screening_obj.time}</span></a>"

      screening_inf = {
        :movie => screening_obj.film.title,
        :showtime_html => showtime_html,
        :theater => screening_obj.theater.name,
        :ticketing_url => screening_obj.ticketing_url
      }
      mday = screening_obj.date_time.mday.to_s
      screenings_hash[mday] ||= []

      if screenings_hash[mday].any?{|info|info.has_value?(screening_inf[:movie])}
        existing_showtime_info = screenings_hash[mday].select{|info|info[:movie] == screening_inf[:movie]}.first
        existing_showtime_info[:showtime_html] << " " << "#{screening_inf[:showtime_html]}"
      else
        screenings_hash[mday] << screening_inf
      end

    end
    screenings_hash
  end

  def self.date_time_to_string(date_time)
    # d.strftime("at %I:%M%p")
    time = date_time.strftime("%I:%M%p")
    return time.slice(1,time.length) if time [0] == "0"
    time
  end
end





