class UsersFilmsController < ApplicationController
  def create

    @watchlist_film = UsersFilm.new(user_id: current_user.id, film_id: params[:film_id])

    respond_to do |format|
      if @watchlist_film.save
        format.json {render :json => {:success => 'film added to your watchlist'} }
      else
        format.json {render :json => {:errors => @watchlist_film.errors} }
      end
    end

  end

  def destroy
  end
end