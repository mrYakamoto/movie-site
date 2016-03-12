
class WelcomeController < ApplicationController
  include CalendarHelper

  def index
    @films = []
    Film.all.each{|film_obj|@films << film_obj}
    @top_three_films_arr = @films.shift(3)
    @fourth_top_film = @films.shift()
    @fifth_and_sixth_top_films_arr = @films.shift(2)

    @this_month_num = DateTime.now().month.to_s
    @this_month_str = Date::MONTHNAMES[Date.today.month]
    @numbers = nums_for_calendar_month
  end


end
