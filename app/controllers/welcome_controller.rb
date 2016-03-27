include UsersHelper

class WelcomeController < ApplicationController

  def index
    # @films = Film.by_popularity.limit(10)


    @films = []
    Film.all.each{|film_obj|@films << film_obj}
    @top_three_films_arr = @films.sample(3)
    @fourth_top_film = @films.sample()
    @fifth_and_sixth_top_films_arr = @films.sample(2)

    @date_filler = DateTime.now()
    @screenings = Screening.all.where("month > ? OR month = ? AND mday >= ?",@date_filler.month, @date_filler.month, @date_filler.mday)
    @theaters = Theater.all

    respond_to do |format|
        format.html
        format.js { render :file => "/screenings/from_theater.js.erb" }
    end
  end

end
