class User < ApplicationRecord
  has_many :orders

  has_secure_password validations: false

  before_save :create_remember_token

  validates :firstname, presence: true, length: { maximum: 30 }
  validates :lastname, presence: true, length: { maximum: 30 }
  validates :email, :format => { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }
  validates :phone, presence: true
  validates :npa, numericality: { only_integer: true, greater_than: 0 }
  validates :city, presence: true, length: { maximum: 30 }
  validates :address, presence: true, length: { maximum: 50 }
  validates :country, presence: true

  def country_name
    country = ISO3166::Country[self.country]
    country.translations[I18n.locale.to_s] || country.name
  end

  def full_name
    "#{firstname} #{lastname}"
  end
  alias name full_name

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
