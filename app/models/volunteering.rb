class Volunteering < ApplicationRecord

  belongs_to :item
  has_many :volunteers
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  
  
end
