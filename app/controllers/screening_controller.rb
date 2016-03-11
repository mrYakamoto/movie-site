class ScreeningController < ApplicationController
  def screenings
    puts "="*50
    puts "="*50
    puts "="*50

    # month = params[:month]
    month = '5'

    @screenings = Screening.full_month_screenings(month)

    puts @screenings

    render json: @screenings, :layout=> false
  end
end
