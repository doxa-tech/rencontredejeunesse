class Order < ApplicationRecord
  KEY = Rails.application.secrets.postfinance_key
  PSPID = Rails.application.secrets.postfinance_pspid
  INVOICE_LIMIT = 800

  attr_accessor :conditions, :lump_sum

  enum payment_method: [:postfinance, :invoice]
  enum case: [:regular, :volunteer]

  belongs_to :user
  belongs_to :product, polymorphic: true, dependent: :destroy
  belongs_to :discount, optional: true

  accepts_nested_attributes_for :product

  validates :conditions, acceptance: true, unless: :pending
  validates :order_id, uniqueness: true
  validates :human_id, uniqueness: true
  validate :validity_of_discount_code

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

  def discount_code
    @discount_code ||= self.discount.try(:code)
  end

  def discount_code=(value)
    self.discount = Discount.find_by_code(value)
    @discount_code = value
  end

  private

  def validity_of_discount_code
    if (discount_code.present? && discount.nil?) || unvalid_discount?
      errors.add(:discount_code, "Le code promotionel n'est pas valide")
    end
  end

  def unvalid_discount?
    discount_id_changed? && discount && (discount.used || discount.product != self.product_type)
  end

  # careful: lump_sum must be set each time an object is saved
  def assign_amount
    if lump_sum
      self.amount = lump_sum
    else
      self.amount = product.calculate_amount
      self.amount = self.discount.calculate_amount(self.amount) if self.discount
    end
  end

  def assign_payment_method
    self.payment_method = "invoice" if (self.amount / 100) > INVOICE_LIMIT
  end

  def generate_id
    loop do
      #self.order_id = Time.now.to_i * rand(1000..9999)
      #               |     2 digits for year      |              10 random digits              | 2 digits |
      self.order_id = (Time.now.year%100)*(10**12) + SecureRandom.random_number(10**10)*(10**2) + 01
      self.human_id = SecureRandom.hex(2).upcase
      break if valid?
    end
  end

end
