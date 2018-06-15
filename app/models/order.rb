class Order < ApplicationRecord
  KEY = Rails.application.secrets.postfinance_key
  PSPID = Rails.application.secrets.postfinance_pspid
  INVOICE_LIMIT = 800

  attr_accessor :conditions, :lump_sum

  enum case: [:regular, :volunteer]

  belongs_to :user
  belongs_to :discount, optional: true
  has_many :items, through: :order_items, dependent: :nullify
  has_many :tickets, through: :registrants, source: :item, dependent: :nullify

  validates :conditions, acceptance: true, unless: :pending
  validates :order_id, uniqueness: true
  validate :validity_of_discount_code

  before_create :generate_id
  after_validation :assign_amount

  def shain
    chain = "AMOUNT=#{amount}#{KEY}CN=#{user.full_name}#{KEY}CURRENCY=CHF#{KEY}"\
            "EMAIL=#{user.email}#{KEY}LANGUAGE=fr_FR#{KEY}ORDERID=#{order_id}#{KEY}"\
            "OWNERADDRESS=#{user.address}#{KEY}OWNERCTY=#{user.country_name}#{KEY}"\
            "OWNERTOWN=#{user.city}#{KEY}OWNERZIP=#{user.npa}#{KEY}PSPID=#{PSPID}#{KEY}"
    return Digest::SHA1.hexdigest(chain)
  end

  def fee
    product.class::FEE
  end

  def discount_code
    @discount_code ||= self.discount.try(:code)
  end

  def discount_code=(value)
    self.discount = Discount.find_by_code(value)
    @discount_code = value
  end

  def pdf_adapter
    case product_type
    when "Records::Rj"
      Adapters::OrderPassRjAdapter.new(self)
    when "Records::Login"
      Adapters::OrderPassLoginAdapter.new(self)
    end
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
      # TODO
      # self.amount = product.calculate_amount
      if self.discount
        self.discount_amount = self.amount - self.discount.calculate_amount(self.amount)
        self.amount = self.discount.calculate_amount(self.amount)
      end
    end
  end

  def generate_id
    loop do
      #               |     2 digits for year      |              10 random digits              | 2 digits |
      self.order_id = (Time.now.year%100)*(10**12) + SecureRandom.random_number(10**10)*(10**2) + 01
      self.human_id = SecureRandom.hex(2).upcase
      break if valid?
    end
  end

end
