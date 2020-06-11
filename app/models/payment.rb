class Payment < ApplicationRecord
  KEY = Rails.application.secrets.postfinance_key
  PSPID = Rails.application.secrets.postfinance_pspid
  INVOICE_LIMIT = 80000
  FDIV = 100 # Float division

  enum payment_type: [:main, :refund, :addition]
  enum method: [:postfinance, :invoice, :cash]

  belongs_to :order

  before_create :generate_id
  before_save :assign_method, :set_time_of_payment
  after_save :update_order

  validates :amount, presence: true
  validates :payment_type, presence: true

  scope :pending_on_postfinance, -> { where(payment_type: :addition, method: :postfinance, status: 41) }

  def shain
    chain = "AMOUNT=#{amount}#{KEY}CN=#{user.full_name}#{KEY}CURRENCY=CHF#{KEY}"\
            "EMAIL=#{user.email}#{KEY}LANGUAGE=fr_FR#{KEY}ORDERID=#{payment_id}#{KEY}"\
            "OWNERADDRESS=#{user.address}#{KEY}OWNERCTY=#{user.country_name}#{KEY}"\
            "OWNERTOWN=#{user.city}#{KEY}OWNERZIP=#{user.npa}#{KEY}PSPID=#{PSPID}#{KEY}"
    return Digest::SHA1.hexdigest(chain)
  end

  def user
    self.order.user
  end

  def update_order
    self.order.update_column(:status, order_status) 
  end

  def order_status
    payments = Payment.where(order: self.order).where.not(id: self.id).to_a << self
    main = payments.find { |p| p.main? }
    if self.order.delivered?
      "delivered"
    elsif main.status == nil
      nil
    elsif payments.select{ |p| p.status == 9 }.inject(0) { |sum, obj| sum + obj.total_amount } == self.order.amount
      "paid"
    elsif payments.any? { |p| p.status == 41 }
      "pending"
    else
      "unpaid"
    end
  end

  def total_amount
    refund_status == 8 ? amount - refund_amount : amount
  end

  private

  def assign_method
    self.method = (self.amount > Payment::INVOICE_LIMIT ? "invoice" : "postfinance")
  end

  def set_time_of_payment
    self.time = Time.current if self.status == 9
  end

  def generate_id
    loop do
      #                 |              14 random digits               |
      self.payment_id = (SecureRandom.random_number(9*10**13) + 10**13)
      break unless Payment.where(payment_id: self.payment_id).exists?
    end
  end

end
