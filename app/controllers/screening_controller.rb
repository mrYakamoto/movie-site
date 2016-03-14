class ScreeningController < ApplicationController
  def screenings
    puts "="*50
    puts "="*50
    puts "="*50

    # month = params[:month]
    month = '3'

    @screenings = Screening.full_month_screenings(month)

    puts @screenings

    render json: @screenings, :layout=> false
  end
end
