class Post < ApplicationRecord
  default_scope { order created_at: :desc }

  belongs_to :user
  belongs_to :image
  has_many :comments, dependent: :destroy

  validates :message, presence: true, length: { maximum: 500 }
  validates :user, presence: true

  def last_comment
    comments.first
  end
end
