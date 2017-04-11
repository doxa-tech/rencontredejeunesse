CarrierWave.configure do |config|
  config.fog_provider = 'fog/google'                        # required

  config.fog_credentials = {
    provider:                         Rails.application.secrets.image_provider,
    google_storage_access_key_id:     Rails.application.secrets.google_storage_access_key_id,
    google_storage_secret_access_key: Rails.application.secrets.google_storage_secret_access_key
  }
  config.fog_directory = 'rj-assets'
end

module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality(percentage) }
        img = yield(img) if block_given?
        img
      end
    end
  end
end