class Scraper

  def self.save_all_posters
    Film.all.each do |film|
      unless ((Scraper.have_poster_file?("poster-#{film.id}"))||(film.poster_url == "NA"))
        open(Rails.root.join('app','assets','images','posters',"poster-#{film.id}.jpg"), 'wb') do |file|
          file << open(film.poster_url).read
        end
      end
    end
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
  end

end