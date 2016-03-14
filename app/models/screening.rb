class Screening < ActiveRecord::Base
  belongs_to :theater
  belongs_to :film



  def self.full_month_screenings(month)
    screenings_arr = Screening.all.where(month: month)
    screenings_hash = {}

    screenings_arr.each do |screening_obj|
      showtime = Screening.date_time_to_string(screening_obj.date_time).downcase
      showtime = showtime.slice(1,showtime.length+1)

      screening_inf = {
        :movie => screening_obj.film.title,
        :showtime => showtime,
        :theater => screening_obj.theater.name
      }
      mday = screening_obj.date_time.mday.to_s
      screenings_hash[mday] ||= []

      if screenings_hash[mday].any?{|info|info.has_value?(screening_inf[:movie])}
        existing_showtime_info = screenings_hash[mday].select{|info|info[:movie] == screening_inf[:movie]}.first
        existing_showtime_info[:showtime] << "|#{screening_inf[:showtime]}"
      else
        screenings_hash[mday] << screening_inf
      end

    end
    screenings_hash
  end

  def self.date_time_to_string(date_time)
    # d.strftime("at %I:%M%p")
    date_time.strftime("%I:%M%p")
  end
end





# screenings_hash[mday].each do |info|
#   if (info.has_value?(screening_inf[:movie]))
#     info[:showtime] << "|#{screening_inf[:showtime]}"
#     screening_inf = {}
#     break
#   end
# end




