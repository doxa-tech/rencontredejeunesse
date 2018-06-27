class Item < ApplicationRecord

    has_many :order_items
    has_many :orders, through: :order_items, dependent: :restrict_with_exception

    has_many :registrants
    has_many :registrations, through: :registrants, source: :order, dependent: :restrict_with_exception

    has_and_belongs_to_many :discounts

    validates :name, presence: true, length: { maximum: 50 }
    validates :description, presence: true, length: { maximum: 250 }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 500 }
    validates :number, presence: true, numericality: { greater_than_or_equal_to: 1000 }

    # TODO: test with rspec
    scope :valid, -> { where("active = ? AND (valid_until IS ? OR valid_until >= ?)", true, nil, Date.current) }

end
