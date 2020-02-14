class Form < ApplicationRecord

  validates :key, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :name, presence: true

  has_many :fields, class_name: "Form::Field", dependent: :destroy

  has_many :order_bundles, dependent: :restrict_with_exception

  def active?
    date = Date.current
    active && (valid_until.nil? || valid_until >= date) && (valid_from.nil? || valid_from <= date)
  end

end
