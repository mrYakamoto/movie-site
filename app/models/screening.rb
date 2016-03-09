class Screening < ActiveRecord::Base
  belongs_to :theater
  belongs_to :films
end
