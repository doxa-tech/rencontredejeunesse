class Volunteer < ApplicationRecord
  include Sectors

  belongs_to :user

  enum sector: self.SECTORS_TO_ENUM

  validates :comment, length: { maximum: 50 }

end
