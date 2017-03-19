class Image < ApplicationRecord
  has_one :post

  mount_uploader :file, ImageUploader

  validates :file, presence: true
end
