class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.string :title
      t.string :poster_url
      t.integer :popularity, {default: 0}

      t.timestamps null: false
    end
  end
end
