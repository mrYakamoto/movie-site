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
  puts "saving new posters"
  Scraper.save_all_posters
  puts "done."
end