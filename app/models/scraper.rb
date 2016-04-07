require 'nokogiri'
require 'open-uri'

include CastroScraperHelper
include ParkwayScraperHelper
include RoxieScraperHelper
include YerbaScraperHelper

class Scraper

  def self.remove_whitespace(string)
    string.gsub(/^\s*|\n\s*|\r\s*|\s{2}|\s*$/,'')
  end

  def self.delete_old_screenings
    now = DateTime.now()
    Screening.all.each do |screening|
      film = screening.film
      if ( (screening.date_time < now)&&(film.screenings.length == 1) )
        film.destroy
        screening.destroy
        puts "destroying #{film.title} screening and film"
      elsif (screening.date_time < now)
        screening.destroy
        puts "destroying #{film.title} screening"
      end
    end
    Rails.logger.info("old screenings deleted at #{Time.now}")
  end

end