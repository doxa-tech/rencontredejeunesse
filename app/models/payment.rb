class Payment < ApplicationRecord
  KEY = Rails.application.secrets.postfinance_key
  PSPID = Rails.application.secrets.postfinance_pspid
  INVOICE_LIMIT = 80000

  enum payment_type: [:main, :refund, :addition]
  enum method: [:postfinance, :invoice, :cash]

  belongs_to :order

  before_validation :assign_method
  after_save :update_order

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

  def assign_method
    self.method ||= (self.amount > INVOICE_LIMIT ? :invoice : :postfinance)
  end

  private

  def update_order
    unless self.order.delivered?
      self.order.update_column(:status, order_status)
    end
  end

  def order_status
    if self.order.payments.where(status: 9).inject(0) { |sum, obj| sum + obj.amount } == self.order.amount
      :paid
    else
      :unpaid
    end
  end

end
