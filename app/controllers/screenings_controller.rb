class ScreeningsController < ApplicationController

  def from_theater
    @date_filler = DateTime.now()
    @screenings = Screening.where(theater_id: params[:theater_id])
    respond_to do |format|
      format.js
    end
  end

end

