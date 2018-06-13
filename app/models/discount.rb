class Discount < ApplicationRecord

  # TODO: no more a product field, but a link to item


  has_many :orders, dependent: :restrict_with_exception

  enum category: [:money, :percent, :free]

  validates :code, uniqueness: true
  validates :category, presence: true, inclusion: { in: categories.keys }
  validates :product, presence: true, inclusion: { in: ["Records::Rj", "Records::Login"] }
  validates :reduction, presence: true, numericality: { greater_than_or_equal_to: 500 }, if: :money?
  validates :reduction, presence: true, numericality: { greater_than: 0, less_than: 100 }, if: :percent?
  validates :number, presence: true, numericality: { greater_than: 0 }, if: :free?

  before_create :generate_code

  def calculate_amount(amount)
    amount = amount - self.calculate_discount(amount)
    if amount == self.product_class::FEE * 100 || amount < 0
      amount = 0
    end
    return amount
  end

  def calculate_discount(amount)
    case category
    when "money"
      self.reduction
    when "percent"
      amount * self.reduction / 100
    when "free"
      self.number * self.product_class.ENTRY_PRICE * 100
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
