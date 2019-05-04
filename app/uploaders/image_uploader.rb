class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{secure_token}.#{file.extension.downcase}" if original_filename.present?
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
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
    process :resize_with_crop => [256, 256, { gravity: :north }]
  end

  process convert: 'jpg'
  process :resize_to_limit => [2500, 2500]
  process :right_orientation

  before :cache, :capture_size
  def capture_size(new_file)
    if model.file_width.nil? || model.file_height.nil?
      model.file_width, model.file_height = ::MiniMagick::Image.open(file.file)[:dimensions]
    end
  end

  def right_orientation
    manipulate! do |img|
      img.auto_orient
      img
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

  protected
  
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
