class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer

  # Choose what kind of storage to use for this uploader:
  # storage :file # Configured in config file initializer
  if Rails.env.production? 
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/post/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    if original_filename
      if model && model.read_attribute(mounted_as).present?
        model.read_attribute(mounted_as)
      else
        "img_#{model.created_at.to_i}.jpg"
      end
    end
  end

  version :l do
    process :resize_to_limit => [1200, nil] 
  end

  version :m do
    process :resize_to_limit => [800, nil] 
  end

  version :thumb do
    process :resize_to_limit => [128, nil] 
  end

  process :check_size
  process convert: 'jpg'
  process :resize_to_limit => [2500, 2500]
  process :right_orientation

  def right_orientation
    manipulate! do |img|
      img.auto_orient
      img
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def check_size
    w, h = ::MiniMagick::Image.open(file.file)[:dimensions]
    if(w < 850 || h < 400)
      raise MiniMagick::Error, "Votre image est trop petite. Une largeur d'au moins 850px et une hauteur d'au moins 400px est nécessaire."
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
