class OrderBundle < ApplicationRecord

  has_many :option_orders, dependent: :destroy
  has_many :items, dependent: :nullify

  belongs_to :order_type
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  
  
end
