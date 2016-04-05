require 'nokogiri'
require 'open-uri'

include CastroScraperHelper
include ParkwayScraperHelper
include RoxieScraperHelper
include YerbaScraperHelper

class Scraper

  def self.save_all_posters
    Film.all.each do |film|
      unless ( (Scraper.have_poster_file?("poster-#{film.id}") )|| (film.poster_url == "NA") )
        open(Rails.root.join('app','assets','images','posters',"poster-#{film.id}.jpg"), 'wb') do |file|
          file << open(film.poster_url).read
        end
      end
    end
    Rails.logger.info("posters updated at #{Time.now}")
  end

  def self.have_poster_file?(file_name)
    if (Rails.application.assets.find_asset "posters/#{file_name}")
      true
    else
      false
    end
  end

  def self.remove_whitespace(string)
    string.gsub(/^\s*|\n\s*|\r\s*|\s{2}|\s*$/,'')
  end


  def self.delete_old_posters
    Dir.foreach(Rails.root.join('app','assets','images','posters')) do |file|
      next if file == '.' or file == '..' or file == 'default.jpg'

      if ( !Film.exists?(file.gsub('/\D/','')) )
        File.delete(Rails.root.join('app','assets','images','posters', file))
      end
    end
    Rails.logger.info("Old posters deleted at #{Time.now}")
  end

  def self.delete_old_screenings
    now = DateTime.now()
    Screening.all.each do |screening|
      film = screening.film
      if ( (screening.date_time < now)&&(film.screenings.length == 1) )
        film.destroy
        screening.destroy
      elsif (screening.date_time < now)
        screening.destroy
      end
    end
    Rails.logger.info("old screenings deleted at #{Time.now}")
  end

end