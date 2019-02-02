class OrderType < ApplicationRecord

  validates :name, presence: true

  has_many :order_bundles, dependent: :restrict_with_exception

  has_many :subtypes, class_name: "OrderType", foreign_key: "supertype_id", dependent: :nullify
  belongs_to :supertype, class_name: "OrderType", optional: true
  belongs_to :form, optional: true
  
end
