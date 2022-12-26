class Payment < ApplicationRecord
  KEY = Rails.application.secrets.postfinance_key
  PSPID = Rails.application.secrets.postfinance_pspid
  INVOICE_LIMIT = 80000
  FDIV = 100 # Float division

  enum payment_type: [:main, :refund, :addition]
  enum method: [:postfinance, :invoice, :cash]
  
  # Postfinance transaction states
  # failed, voided, fullfill, decline are final states
  # transaction:
  # - created -> pending
  # - payment url fetched -> confirmed
  # - client reached payment page -> processing
  # if a payment is failed, we let the client retry
  enum state: [:pending, :confirmed, :processing, :authorized, :completed, :failed, :voided, :fullfill, :decline]

  belongs_to :order

  before_create :generate_id
  before_save :assign_method, :set_time_of_payment
  after_save :update_order

  validates :amount, presence: true
  validates :payment_type, presence: true

  scope :pending_on_postfinance, -> { where(payment_type: :addition, method: :postfinance, state: :pending) }

  def user
    self.order.user
  end

  def update_order
    self.order.update_column(:status, order_status) 
  end

  def order_status(order = self.order)
    # TODO: refund
    payments = Payment.where(order: order).where.not(id: self.id).to_a << self
    main = payments.select{ |p| p.main? }.last
    if order.delivered? 
      "delivered" # delivered is a final state
    elsif main.state.in? Payment.progress_states
      "progress" # the order is still opened
    elsif payments.any? { |p| p.state.in?  Payment.pending_states }
      "pending" # a payment has not reached a final state yet
    elsif payments.select{ |p| p.fullfill? }.inject(0) { |sum, obj| sum + obj.total_amount } >= order.amount
      "paid" # the order is paid
    else 
      "unpaid"
    end 
  end

  def total_amount
    # TODO: refund
    amount
  end

  def self.progress_states
    ["pending", "confirmed", "failed"]
  end

  def self.pending_states
    ["processing", "authorized", "completed"]
  end

  private

  def assign_method
    self.method = (self.amount > Payment::INVOICE_LIMIT ? "invoice" : "postfinance")
  end

  def set_time_of_payment
    self.time = Time.current if self.fullfill?
  end

  def generate_id
    loop do
      #                 |              14 random digits               |
      self.payment_id = (SecureRandom.random_number(9*10**13) + 10**13)
      break unless Payment.where(payment_id: self.payment_id).exists?
    end
  end

end
