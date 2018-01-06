class User < ApplicationRecord
  attr_accessor :current_password
  enum gender: [:male, :female]

  has_many :orders
  has_many :volunteers
  has_many :comments
  belongs_to :image, optional: true

  has_many :posts
  has_many :testimonies

  has_secure_password

  before_save :create_remember_token
  before_create :create_verify_token

  # TODO
  scope :with_account, -> { where.not(password_digest: nil) }

  validates :firstname, presence: true, length: { maximum: 30 }
  validates :lastname, presence: true, length: { maximum: 30 }
  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
  validates :gender, presence: true, inclusion: { in: genders.keys }
  validate :uniqueness_of_email

  validates :phone, format: { with: /\A\+\d{11}\z/ }
  validates :npa, numericality: { only_integer: true, greater_than: 0 }
  validates :city, presence: true, length: { maximum: 30 }
  validates :address, presence: true, length: { maximum: 50 }
  validates :country, presence: true
  validates :birthday, presence: true

  def completed_orders
    Order.where(user_id: self.id).where.not(status: nil)
  end

  def country_name
    country = ISO3166::Country[self.country]
    country.translations[I18n.locale.to_s] || country.name
  end

  def full_name
    "#{firstname} #{lastname}"
  end
  alias name full_name

  def age
    now = Date.today
    age = now.year - birthday.year
    age -= 1 if now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)
    return age
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

  def uniqueness_of_email
    if User.where(email: email).where.not(id: id, password_digest: nil).any?
      errors.add(:email, "L'email est déjà utilisé")
    end
  end
end
