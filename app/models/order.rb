class Order < ApplicationRecord
  KEY = Rails.application.secrets.postfinance_key
  PSPID = Rails.application.secrets.postfinance_pspid

  attr_accessor :conditions

  belongs_to :user
  belongs_to :product, polymorphic: true

  accepts_nested_attributes_for :product, :user

  validates :conditions, acceptance: true

  before_create :generate_id
  before_save :assign_amount

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
    amount / 100
  end

  private

  def assign_amount
    self.amount = product.calculate_amount
  end

  def generate_id
    self.order_id = Time.now.to_i * rand(1000..9999)
  end

end