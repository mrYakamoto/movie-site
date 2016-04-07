class Film < ActiveRecord::Base
  has_attached_file :poster,
  :bucket => 'filmlist-assets'

  after_create :poster_from_url

  validates_attachment :poster,
  content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  has_many :users, through: :users_films
  has_many :screenings

  validates :title, presence: true, uniqueness: true

  scope :by_popularity, -> { order(:popularity => :desc) }

  def all_theaters
    theaters = []
    self.screenings.each do |screening|
      theaters << screening.theater.name if !theaters.include?(screening.theater.name)
    end
    theaters
  end

  private
  def poster_from_url
    if (self.poster_url)
      self.poster = open(self.poster_url)
      self.save
    else
      self.poster = open('https://s3.amazonaws.com/filmlist-assets/films/posters/default.jpg')
      self.save
    end
  end
end