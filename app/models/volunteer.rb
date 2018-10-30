class Volunteer < ApplicationRecord
  include Sectors

  belongs_to :user
  belongs_to :volunteering
  belongs_to :order

  enum option: self.SECTORS_TO_ENUM

  validates :comment, length: { maximum: 50 }
  validates :sector, inclusion: { in: sectors.keys }, allow_nil: true

end
