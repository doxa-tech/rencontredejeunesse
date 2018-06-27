class OrderItem < ApplicationRecord
  belongs_to :order, inverse_of: :order_items
  belongs_to :item

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
end
