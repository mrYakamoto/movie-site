class Screening < ActiveRecord::Base
  belongs_to :theater
  belongs_to :film

  validates :month, :mday, :year, :time, :ticketing_url, :film_id, :theater_id, presence: true

end





