class OrderBundle < ApplicationRecord

  has_many :option_orders
  has_many :items

  belongs_to :order_type
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  
  
end
