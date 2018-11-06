class Item < ApplicationRecord

    has_many :order_items
    has_many :orders, through: :order_items, dependent: :restrict_with_exception

    has_many :registrants
    has_many :registrations, through: :registrants, source: :order, dependent: :restrict_with_exception

    has_and_belongs_to_many :discounts
    belongs_to :order_bundle, optional: true

    validates :name, presence: true, length: { maximum: 50 }
    validates :description, presence: true, length: { maximum: 250 }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 500 }
    validates :number, presence: true, numericality: { greater_than_or_equal_to: 1000 }

    scope :active, -> { where("active = :active AND
      (valid_until IS :null OR valid_until >= :date) AND (valid_from IS :null OR valid_from <= :date)", 
      active: true, null: nil, date: Date.current) 
    }

    def active?
      date = Date.current
      active && (valid_until.nil? || valid_until >= date) && (valid_from.nil? || valid_from <= date)
    end

end
