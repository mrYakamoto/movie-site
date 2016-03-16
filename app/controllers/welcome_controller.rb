include CalendarHelper
include UsersHelper

class WelcomeController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  def index
    @films = []
    Film.all.each{|film_obj|@films << film_obj}
    @top_three_films_arr = @films.sample(3)
    @fourth_top_film = @films.sample()
    @fifth_and_sixth_top_films_arr = @films.sample(2)

    @this_month_num = DateTime.now().month.to_s
    @this_month_str = Date::MONTHNAMES[Date.today.month]
    @numbers = nums_for_calendar_month
  end

end
