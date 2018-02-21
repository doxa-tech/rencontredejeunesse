class Order < ApplicationRecord
  KEY = Rails.application.secrets.postfinance_key
  PSPID = Rails.application.secrets.postfinance_pspid
  INVOICE_LIMIT = 800

  attr_accessor :conditions, :lump_sum
  attr_reader :discount_code

  enum payment_method: [:postfinance, :invoice]
  enum case: [:regular, :volunteer]

  belongs_to :user
  belongs_to :product, polymorphic: true
  belongs_to :discount, optional: true

  accepts_nested_attributes_for :product

  validates :conditions, acceptance: true, unless: :pending
  validates :order_id, uniqueness: true
  validates :human_id, uniqueness: true

  before_create :generate_id
  after_validation :assign_amount, :assign_payment_method, unless: :paid?

  def shain
    chain = "AMOUNT=#{amount}#{KEY}CN=#{user.full_name}#{KEY}CURRENCY=CHF#{KEY}"\
            "EMAIL=#{user.email}#{KEY}LANGUAGE=fr_FR#{KEY}ORDERID=#{order_id}#{KEY}"\
            "OWNERADDRESS=#{user.address}#{KEY}OWNERCTY=#{user.country_name}#{KEY}"\
            "OWNERTOWN=#{user.city}#{KEY}OWNERZIP=#{user.npa}#{KEY}PSPID=#{PSPID}#{KEY}"
    return Digest::SHA1.hexdigest(chain)
  end

  def product_name
    return product_type.demodulize.downcase
  end

  def print_amount
    if amount.present?
      amount / 100
    else
      product.calculate_amount / 100
    end
  end

  def fee
    product.class::FEE
  end

  def paid?
    status == 5 || status == 9
  end

  def discount_code=(value)
    if self.discount = Discount.find_by_code(value)
      @discount_code = value
    else
      errors.add(:discount, "n'est pas valide")
    end
    return @discount_code
  end

  private

  # careful: lump_sum must be set each time an object is saved
  def assign_amount
    self.amount = lump_sum || product.calculate_amount
    self.amount = self.discount.calculate_discount(self.amount)
  end

  def assign_payment_method
    self.payment_method = "invoice" if (self.amount / 100) > INVOICE_LIMIT
  end

  def generate_id
    loop do
      self.order_id = Time.now.to_i * rand(1000..9999)
      self.human_id = SecureRandom.hex(2).upcase
      break if valid?
    end
  end

end
