class AddPosterToFilms < ActiveRecord::Migration
  def self.up
    add_attachment :films, :poster
  end

  def self.down
    remove_attachment :films, :poster
  end
end
