class Refund < ApplicationRecord
  belongs_to :user
  belongs_to :order

  BUNDLE_KEYS = %w(rj-2020 volunteers-rj-20 volunteers-private-rj-20)

  enum refund_type: [:nothing, :discount, :money]

  validates :refund_type, presence: true
  validates :comment, length: { maximum: 150 }

  def orders
    Orders::Event.joins(registrants: [item: :order_bundle]).where(
      status: :paid,
      user: user, 
      registrants: { items: { order_bundles: { key: BUNDLE_KEYS }}}
    ).where.not(
      id: self.class.where(user: user).pluck(:order_id)
    )
  end

end
