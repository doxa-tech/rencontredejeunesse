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
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
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

  version :avatar do
    process :resize_with_crop => [256, 256]
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
    if(w < 400 || h < 400)
      raise MiniMagick::Error, "Votre image est trop petite. Une largeur d'au moins 400px et une hauteur d'au moins 400px est nécessaire."
    end
  end

  def resize_with_crop(w, h, options = {})
    manipulate! do |img|
      gravity = options[:gravity] || :center

      w_original, h_original = [img[:width].to_f, img[:height].to_f]

      op_resize = ''

      # check proportions
      if w_original * h < h_original * w
        op_resize = "#{w.to_i}x"
        w_result = w
        h_result = (h_original * w / w_original)
      else
        op_resize = "x#{h.to_i}"
        w_result = (w_original * h / h_original)
        h_result = h
      end

      w_offset, h_offset = crop_offsets_by_gravity(gravity, [w_result, h_result], [ w, h])

      img.combine_options do |i|
        i.resize(op_resize)
        i.gravity(gravity)
        i.crop "#{w.to_i}x#{h.to_i}+#{w_offset}+#{h_offset}!"
      end

      img
    end
  end

  GRAVITY_TYPES = [ :north_west, :north, :north_east, :east, :south_east, :south, :south_west, :west, :center ]

  def crop_offsets_by_gravity(gravity, original_dimensions, cropped_dimensions)
    raise(ArgumentError, "Gravity must be one of #{GRAVITY_TYPES.inspect}") unless GRAVITY_TYPES.include?(gravity.to_sym)
    raise(ArgumentError, "Original dimensions must be supplied as a [ width, height ] array") unless original_dimensions.kind_of?(Enumerable) && original_dimensions.size == 2
    raise(ArgumentError, "Cropped dimensions must be supplied as a [ width, height ] array") unless cropped_dimensions.kind_of?(Enumerable) && cropped_dimensions.size == 2

    original_width, original_height = original_dimensions
    cropped_width, cropped_height = cropped_dimensions

    vertical_offset = case gravity
      when :north_west, :north, :north_east then 0
      when :center, :east, :west then [ ((original_height - cropped_height) / 2.0).to_i, 0 ].max
      when :south_west, :south, :south_east then (original_height - cropped_height).to_i
    end

    horizontal_offset = case gravity
      when :north_west, :west, :south_west then 0
      when :center, :north, :south then [ ((original_width - cropped_width) / 2.0).to_i, 0 ].max
      when :north_east, :east, :south_east then (original_width - cropped_width).to_i
    end

    return [ horizontal_offset, vertical_offset ]
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
