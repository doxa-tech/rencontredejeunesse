class Volunteering < ApplicationRecord

  belongs_to :item
  has_many :volunteers
  
end
