class Film < ActiveRecord::Base
  has_many :users, through: :users_films
  has_many :screenings

  validates :title, presence: true, uniqueness: true

  scope :by_popularity, -> {
    order(:popularity => :desc)
  }

  def all_theaters
    theaters = []
    self.screenings.each do |screening|
      theaters << screening.theater.name if !theaters.include?(screening.theater.name)
    end
    theaters
  end

end