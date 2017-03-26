class Comment < ApplicationRecord
  default_scope { order created_at: :desc }

  belongs_to :user
  belongs_to :post

  validates :message, presence: true, length: { maximum: 500 }
  validates :user, presence: true
  validates :post, presence: true
end
