class Marker < ApplicationRecord
  validates :lat, presence: true
  validates :lng, presence: true
  validates :title, presence: true
end