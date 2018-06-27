class Testimony < ApplicationRecord
  default_scope { order created_at: :desc }

  belongs_to :user

  before_validation :strip_content

  validates :message, presence: true, length: { maximum: 500 }

  def strip_content
    self.message = self.message.strip unless self.message.nil?
  end
end
