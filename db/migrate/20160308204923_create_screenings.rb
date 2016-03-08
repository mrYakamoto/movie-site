class CreateScreenings < ActiveRecord::Migration
  def change
    create_table :screenings do |t|
      t.datetime :date_time
      t.string :ticketing_url

      t.integer :film_id
      t.integer :theater_id

      t.timestamps null: false
    end
  end
end
