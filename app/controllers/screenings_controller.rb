class ScreeningsController < ApplicationController

  def from_theater
    @theater_id = params[:theater_id]
    @date_filler = DateTime.now()
    @screenings = Screening.where(theater_id: params[:theater_id])

    respond_to do |format|
      format.js
    end
  end

end

