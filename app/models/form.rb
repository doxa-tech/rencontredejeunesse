class Form < ApplicationRecord

  has_many :fields, class_name: "Form::Field"

  has_many :order_types

end
