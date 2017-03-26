class Testimony < ApplicationRecord
  default_scope { order created_at: :desc }

  belongs_to :user

  validates :message, presence: true, length: { maximum: 500 }
  validates :user, presence: true
end
