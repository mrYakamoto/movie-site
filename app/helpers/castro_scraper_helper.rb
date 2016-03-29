require 'nokogiri'
require 'open-uri'
require 'table_parser'

module CastroScraperHelper

  def scrape_castro

    date = DateTime.now()
    month = Date::MONTHNAMES[date.month]
    mday = date.mday
    year = date.year

    html = open("http://www.filmonfilm.org/filmcalendar/?days=60&month=#{month}&day=#{mday}&year=#{year}", "User-Agent" => "foobar").read
    data = Nokogiri::HTML(html)

    table = TableParser::Table.new data, "/html/body/center/table"

    theater_id = Theater.where(name: "Castro Theater").first.id
    ticketing_url = "http://www.castrotheatre.com/p-list.html"

    counter = 0
    castro_column = nil
    until(castro_column)
      castro_column = counter if table[counter].text.downcase.include?('castro')
      counter +=1
    end



    row_num = 0
    while (row_num < table.nodes[0].length) do

      date_str = table.nodes[0][row_num].text

      days_shows = table.nodes[castro_column][row_num].element.css('p')
      if ( days_shows.length > 0 )
        days_shows.each do |show|
          film_title = show.css('a').text


          imdb_url = show.css('a').attr('href').value
          imdb_page = open(imdb_url).read
          imdb_parsed = Nokogiri::HTML(imdb_page)
          if (imdb_parsed.css('div.poster img').length > 0)
            poster_url = imdb_parsed.css('div.poster img').attr('src').value
          else
            poster_url = "NA"
          end

          new_film = Film.create_with(poster_url: poster_url).find_or_create_by!(title: film_title)

          showtimes_arr = show.children.last.text.split(', ')

          showtimes_arr.each do |showtime|
            full_date_showtime_str = "#{date_str} #{showtime}"
            time_obj = Time.parse(full_date_showtime_str)
            date_time_obj = DateTime.new(time_obj.year,time_obj.month,time_obj.mday,time_obj.hour,time_obj.min)

            new_film.screenings.create(date_time: date_time_obj, month: date_time_obj.month, mday: date_time_obj.mday, year: date_time_obj.year, time: showtime, ticketing_url: ticketing_url, theater_id: theater_id)
          end

        end
      end
      row_num += 1
    end
  end



end


