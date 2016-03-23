require 'nokogiri'
require 'open-uri'

module ParkwayScraperHelper

  def scrape_parkway
    html = open("http://thenewparkway.com/").read
    data = Nokogiri::HTML(html)
    all_days = data.css('div.eventDay')

    theater_id = Theater.where(name: "New Parkway").first.id
    theater_root_url = "http://thenewparkway.com/"


    ticketing_site_root = "https://ticketing.us.veezi.com"

    all_days.each do |day|
      day_str = day.css('span.date a').text

      days_listings = day.css('div.event')

      days_listings.each do |listing|
        if listing.css('span.summary').css('a').text.include?("Purchase")
          showtime = listing.css('span.startTime').text
          date_str = "#{day_str} #{showtime}"

          film_title = listing.css('span.summary').text.gsub(' (Purchase Tickets Online)','')
          ticketing_url = listing.css('span.summary').css('a').attr('href').text

          if ticketing_url.include?(ticketing_site_root)
            ticket_html = open(ticketing_url).read
            ticket_data = Nokogiri::HTML(ticket_html)

            poster_url = ticket_data.css('img.poster').attr('src').text
            poster_url = "#{ticketing_site_root}#{poster_url}"
          else
            poster_url = "NA"
          end


          time_obj = Time.parse(date_str)
          date_time_obj = DateTime.new(time_obj.year,time_obj.month,time_obj.mday,time_obj.hour,time_obj.min)
          showtime = format_time(date_time_obj)


          new_film = Film.create_with(poster_url: poster_url).find_or_create_by!(title: film_title)

          new_film.screenings.create(date_time: date_time_obj, month: date_time_obj.month, mday: date_time_obj.mday, year: date_time_obj.year, time: showtime, ticketing_url: ticketing_url, theater_id: theater_id)
        end
      end
    end
  end

  def format_time(date_time_obj)
    time = date_time_obj.strftime("%I:%M%p").downcase
    return time.slice(1,time.length) if time [0] == "0"
    time
  end
end