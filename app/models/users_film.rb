class UsersFilm < ActiveRecord::Base
  belongs_to :user
  belongs_to :film

  validates :film_id, uniqueness: { scope: :user_id, message: "That film's already on your list"}

end