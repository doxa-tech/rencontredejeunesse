class Registrant < ApplicationRecord

  enum gender: [:male, :female]

  validates :gender, presence: true, inclusion: { in: genders.keys }
  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname, presence: true, length: { maximum: 50 }
  validates :birthday, presence: true
  validate :must_be_six_years_old

  belongs_to :order, inverse_of: :registrants
  belongs_to :item

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
end
