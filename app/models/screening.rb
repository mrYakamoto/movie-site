class Screening < ActiveRecord::Base
  belongs_to :theater
  belongs_to :film

  def months_screening(month)

  end
end
