class Image < ApplicationRecord
  attr_accessor :file_width, :file_height

  mount_uploader :file, ImageUploader

  validates :file, presence: true
  validate :file_dimensions

  def file_dimensions
    if self.file_width < 400 || file_height < 400
      errors.add :avatar, "Votre image est trop petite. Une largeur d'au moins 400px et une hauteur d'au moins 400px est nécessaire."
    end
  end
end
