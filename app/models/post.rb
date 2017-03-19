class Post < ApplicationRecord
  belongs_to :user
  belongs_to :image

  validates :message, presence: true, length: { maximum: 500 }
  validates :user, presence: true
end
