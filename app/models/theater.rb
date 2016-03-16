class Theater < ActiveRecord::Base
  has_many :screenings

  validates :name, presence: true, uniqueness: true
end
