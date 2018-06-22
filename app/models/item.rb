class Item < ApplicationRecord

    has_many :order_items
    has_many :orders, through: :order_items, dependent: :restrict_with_exception

    has_many :registrants
    has_many :registrations, through: :registrants, source: :order, dependent: :restrict_with_exception

    has_and_belongs_to_many :discounts

    # TODO: test with rspec
    scope :valid, -> { where("active = ? AND (valid_until IS ? OR valid_until >= ?)", true, nil, Date.current) }

end
