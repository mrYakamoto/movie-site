class User < ActiveRecord::Base
  has_secure_password
  has_many :films, through: :users_films

end
