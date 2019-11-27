class OrderItem < ApplicationRecord
  belongs_to :order, inverse_of: :order_items
  belongs_to :item

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :validity_of_item

  private

  def validity_of_item
    if (item.nil? || !item.active?) && !order.admin
      errors.add(:item, :exclusion)
    end
  end
end
