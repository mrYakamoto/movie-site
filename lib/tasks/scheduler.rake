desc "This task is called by the Heroku scheduler add-on"
task :update_data => :environment do
  puts "Deleting old screenings"
  Scraper.delete_old_screenings
  puts "Deleting old posters"
  Scraper.delete_old_posters
  puts "scraping Castro"
  Scraper.new.scrape_castro
  puts "scraping Yerba"
  Scraper.new.scrape_yerba
  puts "scraping Roxie"
  Scraper.new.scrape_roxie
  puts "scraping Parkway"
  Scraper.new.scrape_parkway
end

task :save_all_posters => :environment do
  puts "saving new posters"
  Scraper.save_all_posters
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

