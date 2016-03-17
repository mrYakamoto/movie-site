class UsersFilmsController < ApplicationController
  def create
    film = Film.find(params[:film_id])
    current_user.films << film
    head :ok, content_type: "text/html"
  end

  def destroy
  end
end