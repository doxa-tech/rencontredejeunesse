class Form < ApplicationRecord

  validates :key, presence: true, uniqueness: true
  validates :name, presence: true

  has_many :fields, class_name: "Form::Field", dependent: :destroy

  has_many :order_types, dependent: :restrict_with_exception

end
