class WelcomeController < ApplicationController
  def index
    @films = []
    Film.all.each{|film_obj|@films << film_obj}
    @top_three_films_arr = @films.shift(3)
    @fourth_top_film = @films.shift()
    @fifth_and_sixth_top_films_arr = @films.shift(2)
  end
end
