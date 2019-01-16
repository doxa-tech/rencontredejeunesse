class OrderType < ApplicationRecord

  has_many :order_bundles

  has_many :subtypes, class_name: "OrderType", foreign_key: "supertype_id"
  belongs_to :supertype, class_name: "OrderType", optional: true
  belongs_to :form
  
end
