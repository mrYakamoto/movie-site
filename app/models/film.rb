class Film < ActiveRecord::Base
  has_many :users, through: :users_films
  has_many :screenings

  validates :title, presence: true, uniqueness: true
end


