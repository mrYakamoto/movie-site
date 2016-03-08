class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.string :title
      t.string :poster_url

      t.timestamps null: false
    end
  end
end
