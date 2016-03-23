require 'nokogiri'
require 'open-uri'

module YerbaScraperHelper

  def scrape_yerba
    html = open("http://www.ybca.org/programs/upcoming/film-and-video").read
    data = Nokogiri::HTML(html)
    all_listings = data.css('div.view-content div.views-row')

    theater_id = Theater.where(name: "Yerba Buena Center for the Arts").first.id
    theater_root_url = "http://www.ybca.org"

    all_listings.each do |listing|
      film_title = listing.css('div.views-field-title').text
      film_title = remove_whitespace(film_title)

      show_rel_url = listing.css('div.views-field-title a').attr('href').value
      ticketing_url = "#{theater_root_url}#{show_rel_url}"

      hero_image_src = listing.css('div.views-field-field-hero-image img').attr('src').value

      date_str = listing.css('div.views-field-field-performance-times span').text
      time_obj = Time.parse(date_str)
      date_time_obj = DateTime.new(time_obj.year,time_obj.month,time_obj.mday,time_obj.hour,time_obj.min)
      showtime = format_time(date_time_obj)

      new_film = Film.create_with(poster_url: hero_image_src).find_or_create_by!(title: film_title)

      new_film.screenings.create(date_time: date_time_obj, month: date_time_obj.month, mday: date_time_obj.mday, year: date_time_obj.year, time: showtime, ticketing_url: ticketing_url, theater_id: theater_id)
    end
  end


  def remove_whitespace(string)
    string.gsub(/^\s*|\n\s*|\r\s*|\s{2}|\s*$/,'')
  end

  def format_time(date_time_obj)
    time = date_time_obj.strftime("%I:%M%p").downcase
    return time.slice(1,time.length) if time [0] == "0"
    time
  end

end


