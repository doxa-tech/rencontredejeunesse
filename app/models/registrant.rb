class Registrant < ApplicationRecord

  enum gender: [:male, :female]

  validates :gender, inclusion: { in: genders.keys }
  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname, presence: true, length: { maximum: 50 }
  validates :birthday, presence: true
  validate :must_be_six_years_old
  validate :validity_of_item

  belongs_to :order, inverse_of: :registrants
  belongs_to :item

  before_create :generate_id

  # for compatibility with order/item
  def quantity
    1
  end

  def age
    unless birthday.nil?
      now = Date.today
      age = now.year - birthday.year
      age -= 1 if now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)
      return age
    end
  end

  private

  def must_be_six_years_old
    if birthday && (birthday.to_date + 6.years) > Date.today
      errors.add(:birthday, :too_young, age: "6")
    end
  end

  def validity_of_item
    unless item && item.active?
      errors.add(:item, :exclusion)
    end
  end

  private

  def generate_id
    loop do
      #               |     2 digits for year      |              10 random digits               | 2 digits |
      self.ticket_id = (Time.now.year%100)*(10**12) + (SecureRandom.random_number(9*10**9)+10**9) * (10**2) + 01
      break unless Registrant.where(ticket_id: self.ticket_id).exists?
    end
  end

end
