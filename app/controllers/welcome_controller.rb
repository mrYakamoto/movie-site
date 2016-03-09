class WelcomeController < ApplicationController
  def index
    @films = Film.all
  end
end
