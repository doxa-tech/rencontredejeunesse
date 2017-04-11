class Comment < ApplicationRecord
  default_scope { order created_at: :desc }

  belongs_to :user
  belongs_to :post

  before_validation :strip_content

  validates :message, presence: true, length: { maximum: 500 }
  validates :user, presence: true
  validates :post, presence: true

  def strip_content
    self.message = self.message.strip unless self.message.nil?
  end
end
