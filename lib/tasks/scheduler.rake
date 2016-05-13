require 'net/http'

desc "This task is called by the Heroku scheduler add-on to keep dyno awake"
task :ping_site => :environment do
  # utc is 5 hours ahead of CST
  utc_time_now = Time.now.utc
  unless ( (utc_time_now.hour >= 3)&&(utc_time_now.hour <= 12 ) )
    if ENV['URL']
      puts "Sending ping"
      uri = URI(ENV['URL'])
      Net::HTTP.get_response(uri)
      puts "success..."
    end
  end
end

desc "This task is called by the Heroku scheduler add-on"
task :update_data => :environment do
  puts "scraping Castro"
  Scraper.new.scrape_castro
  puts "scraping Yerba"
  Scraper.new.scrape_yerba
  puts "scraping Roxie"
  Scraper.new.scrape_roxie
  puts "scraping Parkway"
  Scraper.new.scrape_parkway
end

task :destroy_old_screenings => :environment do
  puts "clearing old screenings"
  Scraper.delete_old_screenings
end


# task :delete_old_screenings => :environment do
#   Scraper.delete_old_screenings
# end
# task :delete_old_posters => :environment do
#   Scraper.delete_old_posters
# end
# task :scrape_castro => :environment do
#   Scraper.new.scrape_castro
# end
# task :scrape_yerba => :environment do
#   Scraper.new.scrape_yerba
# end
# task :scrape_roxie => :environment do
#   Scraper.new.scrape_roxie
# end
# task :scrape_parkway => :environment do
#   Scraper.new.scrape_parkway
# end