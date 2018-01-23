class Volunteer < ApplicationRecord
  include Sectors

  belongs_to :user

  enum sector: self.SECTORS_TO_ENUM

end
