class User < ActiveRecord::Base
  has_secure_password
  has_many :users_films
  has_many :films, through: :users_films

  validates :username, presence: true, uniqueness: true, length: { in: 4..12 }
  validates :email, presence: true, uniqueness: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :password_digest, presence: true

  def is_admin?
    return self.username == "mr.gregory"
  end

end