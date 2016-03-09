class UsersFilms < ActiveRecord::Migration
  def change
    create_table :users_films, :id => false do |t|
      t.integer :user_id
      t.integer :film_id
    end
  end
end
