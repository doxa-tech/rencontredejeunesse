class User < ApplicationRecord
  attr_accessor :current_password
  enum gender: [:male, :female]

  has_many :orders, dependent: :nullify
  has_many :option_orders
  has_many :comments, dependent: :destroy
  belongs_to :image, optional: true

  has_many :posts, dependent: :destroy
  has_many :testimonies, dependent: :destroy

  has_secure_password

  before_save :create_remember_token, :format_input
  before_create :create_verify_token

  validates :firstname, presence: true, length: { maximum: 30 }
  validates :lastname, presence: true, length: { maximum: 30 }
  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
  validates :gender, presence: true
  validate :uniqueness_of_email

  validates :phone, format: { with: /\A\+\d{11}\z/ }
  validates :npa, numericality: { only_integer: true, greater_than: 0 }
  validates :city, presence: true, length: { maximum: 30 }
  validates :address, presence: true, length: { maximum: 50 }
  validates :country, presence: true
  validates :birthday, presence: true
  validate :must_be_thirteen_years_old

  # password reset
  validates :password, presence: true, on: :reset

  def completed_orders
    Order.where(user_id: self.id).where(status: [:paid, :unpaid, :delivered]).order(:created_at)
  end

  def pending_orders
    Order.where(user_id: self.id, pending: true).order(:created_at)
  end

  def country_name
    unless self.country.nil?
      country = ISO3166::Country[self.country]
      country.translations[I18n.locale.to_s] || country.name
    end
  end

  def full_name
    "#{firstname} #{lastname}"
  end
  alias name full_name

  def age
    unless birthday.nil?
      now = Date.today
      age = now.year - birthday.year
      age -= 1 if now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)
      return age
    end
  end

  def update_with_password(params)
    authenticated = authenticate(params[:current_password])
    assign_attributes(params)
    if valid?(:account_update) && authenticated
      save
      true
    else
      errors.add(:current_password, "Le mot de passe actuel ne correspond pas") unless authenticated
      false
    end
  end

  def avatar_url
    if image.nil?
      "https://storage.googleapis.com/rj-assets/default_avatar.png"
    else
      image.file.avatar.url
    end
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def create_verify_token
    self.verify_token = SecureRandom.urlsafe_base64
  end

  def must_be_thirteen_years_old
    if birthday && (birthday.to_date + 13.years) > Date.today
      errors.add(:birthday, :too_young, age: "13")
    end
  end

  def uniqueness_of_email
    if User.where(email: email).where.not(id: id, password_digest: nil).any?
      errors.add(:email, "L'email est déjà utilisé")
    end
  end

  def format_input
    self.firstname = self.firstname.strip.split('-').map(&:capitalize).join('-')
    self.lastname = self.lastname.strip.split('-').map(&:capitalize).join('-')
    self.email = self.email.strip.downcase
    self.address = self.address.capitalize
    self.city = self.city.capitalize
  end
end
