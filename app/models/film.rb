class Film < ActiveRecord::Base
  has_attached_file :poster

  before_create :check_poster_url
  before_create :poster_from_url

  validates_attachment_presence :poster
  validates_attachment :poster,
  content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }


  has_many :users, through: :users_films
  has_many :screenings

  validates :title, presence: true, uniqueness: true

  scope :by_popularity, -> {
    order(:popularity => :desc)
  }

  def poster_from_url(url)
      self.poster = open(self.poster_url)
  end

  def all_theaters
    theaters = []
    self.screenings.each do |screening|
      theaters << screening.theater.name if !theaters.include?(screening.theater.name)
    end
    theaters
  end

  private

  def check_poster_url
    self.poster_url ||= "https://s3.amazonaws.com/filmlist-assets/films/posters/default.jpg"
  end

end