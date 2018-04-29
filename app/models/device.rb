class Device < ApplicationRecord
  enum platform: [:Android, :iOS]

  validates :token, presence: true, uniqueness: true
  validates :platform, inclusion: { in: platforms.keys }

end
