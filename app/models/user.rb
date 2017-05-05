class User < ApplicationRecord
  attr_accessor :current_password
  enum gender: [:male, :female]

  has_many :orders
  has_many :volunteers
  has_many :comments
  belongs_to :image, optional: true

  has_many :posts
  has_many :testimonies

  has_secure_password validations: false

  before_save :create_remember_token

  scope :with_account, -> { where.not(password_digest: nil) }

  validates :firstname, presence: true, length: { maximum: 30 }
  validates :lastname, presence: true, length: { maximum: 30 }
  validates :email, :format => { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
  validates :gender, presence: true
  validate :uniqueness_of_email

  validates :password, presence: true, length: { maximum: 72 }, on: :account_setup
  validates_confirmation_of :password, on: :account_setup

  validates :password, length: { maximum: 72 }, on: :account_update
  validates_confirmation_of :password, allow_blank: true, on: :account_update

  validates :phone, presence: true, on: :order
  validates :npa, numericality: { only_integer: true, greater_than: 0 }, on: :order
  validates :city, presence: true, length: { maximum: 30 }, on: :order
  validates :address, presence: true, length: { maximum: 50 }, on: :order
  validates :country, presence: true, on: :order
  validates :birthday, presence: true, on: :order


  def country_name
    country = ISO3166::Country[self.country]
    country.translations[I18n.locale.to_s] || country.name
  end

  def full_name
    "#{firstname} #{lastname}"
  end
  alias name full_name

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

  def uniqueness_of_email
    puts "HERRRE"
    if User.where(email: email).where.not(id: id, password_digest: nil).any?
      errors.add(:email, "L'email est déjà utilisé")
    end
  end
end
