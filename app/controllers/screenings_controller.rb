class ScreeningsController < ApplicationController

  def from_theater
    @theater_id = params[:theater_id]
    @date_filler = DateTime.now()
    @screenings = Screening.where(theater_id: params[:theater_id])
    @screenings = @screenings.where("month > ? OR month = ? AND mday >= ?",@date_filler.month, @date_filler.month, @date_filler.mday)

    respond_to do |format|
      format.js
    end
  end

end

