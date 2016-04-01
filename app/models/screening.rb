class Screening < ActiveRecord::Base
  belongs_to :theater
  belongs_to :film

  validates :month, :mday, :year, :time, :ticketing_url, :film_id, :theater_id, presence: true

  validates_uniqueness_of :date_time, :scope => [:film_id, :theater_id]

  def buzz_box_screening_date
    self.date_time.strftime("%a %_m/%-d")
  end
  def buzz_box_screening_time
    self.date_time.strftime("%_I:%M%P")
  end

end