include UsersHelper

class WelcomeController < ApplicationController

  def index
    # @films = Film.by_popularity.limit(10)


    @films = []
    Film.by_popularity.each{|film_obj|@films << film_obj}

    @date_filler = DateTime.now()
    now_plus_20min = (@date_filler + (30/1440.0))
    @screenings = Screening.all.where("date_time >= ?", now_plus_20min)
    @theaters = Theater.all

    respond_to do |format|
        format.html
        format.js { render :file => "/screenings/from_theater.js.erb" }
    end
  end

end
