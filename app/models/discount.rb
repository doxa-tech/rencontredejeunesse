class Discount < ApplicationRecord

  has_one :order

  enum category: [:money, :percent, :free]

  validates :category, presence: true, inclusion: { in: categories.keys }
  validates :product, presence: true, inclusion: { in: ["Records::Rj", "Records::Login"] }
  validates :reduction, if: [:money?, :percent?]
  validates :number, if: :free?

  before_create :generate_code

  def calculate_discount(amount)

  end

  private

  def generate_code

  end

end
