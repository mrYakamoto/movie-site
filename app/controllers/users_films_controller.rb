class UsersFilmsController < ApplicationController
  def create

    @watchlist_film = UsersFilm.new(user_id: current_user.id, film_id: params[:film_id])

    @film = Film.find(params[:film_id])
    @film.popularity += 1
    @film.save

    respond_to do |format|
      if @watchlist_film.save
        format.json {render :json => {:success => 'film added to your watchlist'}}
      else
        format.json {render :json => {:errors => @watchlist_film.errors} }
      end
    end

  end

  def destroy
    film = Film.find(params[:film_id])
    film.popularity -= 1
    film.save

    if current_user.films.delete(film)
      respond_to do |format|  ## Add this
        format.json { render :json => {:success => 'film removed from your watchlist'}, head: :ok, status: :ok }
      end
    else
      respond_to do |format|  ## Add this
        format.json { render :json => {:success => 'film removed from your watchlist'},status: :ok, head: :ok  }
      end
    end
  end
end