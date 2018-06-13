class Item < ApplicationRecord

    has_many :orders, through: :order_items, dependent: :restrict_with_exception
    has_many :registrations, through: :registrants, source: :order, dependent: :restrict_with_exception

end
