class Discount < ApplicationRecord

  has_one :order

  enum category: [:money, :percent, :free]

  validates :category, presence: true, inclusion: { in: categories.keys }
  validates :product, presence: true, inclusion: { in: ["Records::Rj", "Records::Login"] }
  validates :reduction, presence: true, numericality: { greater_than: 0 }, if: [:money?, :percent?]
  validates :number, presence: true, numericality: { greater_than: 0 }, if: :free?

  before_create :generate_code

  def calculate_discount(amount)
    case category
    when "money"
      return amount - self.reduction
    when "percent"
      return amount - (amount * self.reduction / 100)
    when "free"
      return amount - self.number * self.product_class.ENTRY_PRICE
    end
  end

  def product_class
    product.constantize
  end

  private

  def generate_code
    loop do
      self.code = SecureRandom.hex(2).upcase
      break if valid?
    end
  end

end
