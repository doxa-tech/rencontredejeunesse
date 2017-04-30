class Image < ApplicationRecord

  mount_uploader :file, ImageUploader

  validates :file, presence: true
end
