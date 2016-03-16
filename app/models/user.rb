class User < ActiveRecord::Base
  has_secure_password
  has_many :films, through: :users_films


  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true


  def is_admin?
    return self.username == "mr.gregory"
  end

end
