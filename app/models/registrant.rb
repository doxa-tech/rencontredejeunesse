class Registrant < ApplicationRecord

  enum gender: [:male, :female]

  belongs_to :order, inverse_of: :registrants
  belongs_to :item

  def quantity
    1
  end
end
