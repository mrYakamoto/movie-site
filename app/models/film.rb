class Film < ActiveRecord::Base
  has_many :users, through: :users_films
  has_many :screenings

  validates :title, uniqueness: true
end
