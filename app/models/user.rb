class User < ActiveRecord::Base
  has_secure_password
  has_many :films, through: :users_films

  validate :username, { :presence => true, :uniqueness => true, :before => :create }
  validate :email, { :presence => true, :uniqueness => true, :before => :create }

end
