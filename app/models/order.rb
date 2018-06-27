class Order < ApplicationRecord
  attr_accessor :conditions

  enum order_type: [:regular, :event]
  enum status: [:unpaid, :paid, :delivered]

  belongs_to :user
  belongs_to :discount, optional: true

  has_many :order_items, inverse_of: :order
  has_many :items, through: :order_items, dependent: :destroy
  
  has_many :registrants, inverse_of: :order do
    def build_from_user(user)
      build(user.as_json(only: [:gender, :firstname, :lastname, :birthday]))
    end
  end
  has_many :tickets, through: :registrants, source: :item, dependent: :destroy

  has_many :payments, dependent: :destroy, autosave: true

  accepts_nested_attributes_for :registrants, allow_destroy: true, reject_if: :all_blank

  validates :order_type, inclusion: { in: order_types.keys }, allow_nil: true
  validates :status, inclusion: { in: statuses.keys }, allow_nil: true
  validates :conditions, acceptance: true, unless: :pending
  validates :order_id, uniqueness: true
  validate :validity_of_discount_code

  before_create :generate_id
  before_validation :assign_amount
  before_save :assign_payment

  def fee
    self.amount == 0 ? 0 : 500
  end

  def discount_code
    @discount_code ||= self.discount.try(:code)
  end

  def discount_code=(value)
    self.discount = Discount.find_by_code(value)
    @discount_code = value
  end

  def main_payment
    @main_payment ||= Payment.find_by(order_id: self.id, payment_type: :main)
  end

  private

  def validity_of_discount_code
    if (discount_code.present? && discount.nil?) || unvalid_discount?
      errors.add(:discount_code, "Le code promotionel n'est pas valide")
    end
  end

  def unvalid_discount?
    discount_id_changed? && discount && discount.used
  end

  def assign_amount
    self.amount = calculate_amount
    if self.discount
      self.discount_amount = self.discount.calculate_discount(self)
      self.discount_amount = self.amount if self.discount_amount > self.amount
      self.amount = self.amount - self.discount_amount
    end
    self.amount += self.fee
  end

  def calculate_amount
    self.order_items.select { |i| !i.marked_for_destruction? }.inject(0) do |sum, obj|
      (obj.quantity > 0 && !obj.item.nil?) ? (sum + obj.quantity * obj.item.price) : sum
    end
  end

  def assign_payment
    if !main_payment.nil? && main_payment.status.nil?
      main_payment.update_attributes(amount: self.amount)
    elsif main_payment.nil?
      @main_payment = self.payments.build(amount: self.amount, payment_type: :main)
    end
    self.status = self.main_payment.order_status
  end

  def generate_id
    loop do
      #               |     2 digits for year      |              10 random digits               | 2 digits |
      self.order_id = (Time.now.year%100)*(10**12) + (SecureRandom.random_number(9*10**9)+10**9) * (10**2) + 01
      break unless Order.where(order_id: self.order_id).exists?
    end
  end

end
