require 'nokogiri'
require 'open-uri'

module CastroScraperHelper

  def scrape_castro

    date = DateTime.now()
    month = Date::MONTHNAMES[date.month]
    mday = date.mday
    year = date.year

    html = open("http://www.filmonfilm.org/filmcalendar/?days=60&month=#{month}&day=#{mday}&year=#{year}", "User-Agent" => "foobar").read
    data = Nokogiri::HTML(html)


    all_listings = data.css('center tbody tr')

    theater_id = Theater.where(name: "Castro Theater").first.id
    ticketing_url = "http://www.castrotheatre.com/p-list.html"

    padding = [0, 0]

    all_listings.each do |day|



      date_node = day > 'td' > 'b'
      date_str = date_node[0].text

      nth_child = 4
      if (padding[0] > 0 )
        nth_child -= 1
      end
      if (padding[1] > 0)
        nth_child -= 1
      end
      castro_node = day > 'td:nth-child(2)'
      screenings = castro_node.css('p')
      byebug
      screenings.each do |screening|

        film_title = screening.children.first.text
        imdb_url = screening.children.first.attr('href')
        showtimes = screening.children.last.text.split(', ')


        imdb_page = open(imdb_url).read
        imdb_parsed = Nokogiri::HTML(imdb_page)
        poster_url = imdb_parsed.css('div.poster img').attr('src').value
        byebug
        showtimes.each do |showtime|
          full_date_showtime_str = "#{showtime} #{date_str}"
          time_obj = Time.parse(full_date_showtime_str)
          date_time_obj = DateTime.new(time_obj.year,time_obj.month,time_obj.mday,time_obj.hour,time_obj.min)


          new_film = Film.create_with(poster_url: poster_url).find_or_create_by!(title: film_title)

          new_film.screenings.create!(date_time: date_time_obj, month: date_time_obj.month, mday: date_time_obj.mday, year: date_time_obj.year, time: showtime, ticketing_url: ticketing_url, theater_id: theater_id)
        end
      end
    end
  end

  def save_all_posters
    Film.all.each do |film|
      unless have_poster_file?("poster-#{film.id}")
        open(Rails.root.join('app','assets','images','posters',"poster-#{film.id}.jpg"), 'wb') do |file|
          file << open(film.poster_url).read
        end
      end
    end
  end


  def have_poster_file?(file_name)
    Rails.application.assets.find_asset "posters/#{file_name}" ? true : false
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
    time = date_time_obj.strftime("%I:%M%p").downcase
    return time.slice(1,time.length) if time [0] == "0"
    time
  end

end


