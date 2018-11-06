class OptionOrder < ApplicationRecord
  include Sectors

  belongs_to :user
  belongs_to :order_bundle
  belongs_to :order, autosave: true

  enum sector: self.SECTORS_TO_ENUM

  validates :comment, length: { maximum: 50 }
  validates :sector, inclusion: { in: sectors.keys }, allow_nil: true

  def build_order(user, item)
    # TODO: readonly order
    self.order = Orders::Event.new(user: user)
    self.order.registrants.build_from_user(user)
    self.order.registrants.first.item = item
  end

end
