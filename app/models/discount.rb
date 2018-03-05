class Discount < ApplicationRecord

  has_many :orders

  enum category: [:money, :percent, :free]

  validates :code, uniqueness: true
  validates :category, presence: true, inclusion: { in: categories.keys }
  validates :product, presence: true, inclusion: { in: ["Records::Rj", "Records::Login"] }
  validates :reduction, presence: true, numericality: { greater_than: 1000 }, if: :money?
  validates :reduction, presence: true, numericality: { greater_than: 0, less_than: 100 }, if: :percent?
  validates :number, presence: true, numericality: { greater_than: 0 }, if: :free?

  before_create :generate_code

  def calculate_discount(amount)
    case category
    when "money"
      return amount - self.reduction
    when "percent"
      return amount - (amount * self.reduction / 100)
    when "free"
      amount = amount - self.number * self.product_class.ENTRY_PRICE * 100
      amount = 0 if amount == self.product_class::FEE * 100
      return amount
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
