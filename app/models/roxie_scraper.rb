require 'nokogiri'
require 'open-uri'

class RoxieScraper
  attr_reader :calendar_url
  @@calendar_url = 'http://www.roxie.com/calendar/'

  def self.ingest
    data = RoxieScraper.scrape

    year = Time.parse(data['month_year']).year
    month = Time.parse(data['month_year']).month

    urls = data["urls"]

    data.except!("month_year")
    data.except!("urls")

    data.keys.each do |mday|
      data[mday].each do |movie_title, showtimes|

        if (Film.where(title: movie_title).first)
          film_obj = Film.where(title: movie_title).first
        else
          film_obj = Film.create(title: movie_title)
        end


        showtimes.each do |showtime|
          time = Time.parse(showtime)
          hour = time.hour
          min = time.min
          mday = mday.to_i

          roxie_id = Theater.where(name:"Roxie Theater").first.id

          datetime = DateTime.new(year, month, mday, hour, min)
          url = urls[movie_title]

          film_obj.screenings.create(date_time: datetime, month: month, mday: mday, ticketing_url: url, theater_id: roxie_id )
        end
      end

    end
  end


  def self.scrape
    html = open(@@calendar_url)

    calendar = Nokogiri::HTML(html.read.gsub!("&nbsp;",""))
    month_year = calendar.css('.ai1ec-calendar-title').text

    full_days = calendar.css('.ai1ec-day')

    data = {}
    urls = {}



    full_days.each do |day|
      date = day.css('.ai1ec-date').text
      movies = []
      showtimes = []
      last = ""

      day.traverse do |node|
        if ( node["class"] == 'roxie-showtimes-month' )
          last = "movie"
          url = node.children.attribute('href').value
          urls[node.text] = url

          movies << node.text
        elsif ( node["class"] == 'now-playing-times-month' )

          if last == "movie"
            showtimes << Array(node.text)
            last = "showtime"
          elsif last == "showtime"
            showtimes[-1] = showtimes[-1] << node.text
            last = "showtime"
          end

        end
        data[date] = Hash[movies.zip(showtimes)]
        data['month_year'] = month_year
        data["urls"] = urls
      end
    end
    data
  end


end




