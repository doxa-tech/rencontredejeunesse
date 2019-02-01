class OrderBundle < ApplicationRecord

  has_many :option_orders, dependent: :restrict_with_exception
  has_many :items, dependent: :nullify

  belongs_to :order_type
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  validates :key, presence: true, length: { maximum: 20 }
  
end
