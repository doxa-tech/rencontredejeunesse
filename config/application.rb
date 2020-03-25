require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rencontredejeunesse
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |g|
      g.test_framework  nil
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
      g.factory_bot     false
    end

    config.i18n.default_locale = :fr
    config.time_zone = 'Bern'
    config.i18n.available_locales = :fr

    config.action_view.default_form_builder = "StandardFormBuilder"

    config.eager_load_paths += ["#{Rails.root}/lib"]

    # Mailer
    config.action_mailer.smtp_settings = {
      address:              Rails.application.secrets.email_smtp,
      port:                 587,
      user_name:            Rails.application.secrets.email_address,
      password:             Rails.application.secrets.email_pwd,
    }

  end
end
