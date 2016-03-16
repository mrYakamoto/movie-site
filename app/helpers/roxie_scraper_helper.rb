require 'nokogiri'
require 'open-uri'

module RoxieScraperHelper

  def scrape_mobile_site
    html = open("https://ticketing.us.veezi.com/sessions/?siteToken=4m48btf3yavn7xjk5yxk6nc40c").read
    data = Nokogiri::HTML(html)
    js_data = data.css('script')[8]

    all_listings = js_data.child.text.split('},{')

    theater_id = Theater.where(name: "Roxie Theater").first.id

    all_listings.each do |listing|
      date_str = listing.match(/\"startDate\":\"(.*)\",\"duration/)[1]
      time_obj = Time.parse(date_str)
      date_time_obj = DateTime.new(time_obj.year,time_obj.month,time_obj.mday,time_obj.hour,time_obj.min)

      showtime = format_time(date_time_obj)

      narrow_info = listing.match(/\"Roxie Theater\"},\"name\":\"(.*)\",\"@context\"/)[1]

      film_title = narrow_info.match(/^(.*)\",\"url\"/)[1]
      ticketing_url = narrow_info.match(/,\"url\":\"(.*)/)[1]



      poster_url = data.css('img').find{|x|x['alt'] == film_title}['src']
      poster_url = url_root << poster_url

      new_film = Film.create_with(poster_url: poster_url).find_or_create_by!(title: film_title)


      new_film.screenings.create!(date_time: date_time_obj, month: date_time_obj.month, mday: date_time_obj.mday, year: date_time_obj.year, time: showtime, ticketing_url: ticketing_url, theater_id: theater_id)

    end
  end


  def url_root
    "https://ticketing.us.veezi.com"
  end

  def remove_whitespace(string)
    string.gsub(/^\s*|\n\s*|\r\s*|\s{2}|\s*$/,'')
  end

  def this_year
    DateTime.now().year.to_s
  end

  def format_time(date_time_obj)
    time = date_time_obj.strftime("%I:%M%p".downcase)
    return time.slice(1,time.length) if time [0] == "0"
    time
  end

end


