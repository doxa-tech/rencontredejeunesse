class Volunteer < ApplicationRecord
  include Sectors

  belongs_to :user

  enum sector: self.SECTORS_TO_ENUM
  enum tshirt_size: [:xs, :m, :l, :xl]

  validates :comment, length: { maximum: 50 }
  validates :sector, presence: true, inclusion: { in: sectors.keys }
  validates :tshirt_size, presence: true, inclusion: { in: tshirt_sizes.keys }

end
