class Post < ApplicationRecord
  default_scope { order created_at: :desc }

  belongs_to :user
  belongs_to :image, optional: true
  has_many :comments, dependent: :destroy

  before_validation :strip_content

  validates :message, presence: true, length: { maximum: 500 }
  validates :user, presence: true

  def last_comment
    comments.first
  end

  def strip_content
    self.message = self.message.strip unless self.message.nil?
  end
end
