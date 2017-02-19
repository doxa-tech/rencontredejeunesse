require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rencontredejeunesse
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.test_framework  nil
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
      g.factory_girl    false
    end

    config.i18n.default_locale = :fr
    config.time_zone = 'Bern'
    config.i18n.available_locales = :fr

    config.action_view.default_form_builder = "StandardFormBuilder"

    # Mailer
    config.action_mailer.smtp_settings = {
      address:              'mail.infomaniak.ch',
      port:                 587,
      user_name:            'noreply@rencontredejeunesse.ch',
      password:             Rails.application.secrets.email_pwd,
    }

    config.action_mailer.asset_host = 'rencontredejeunesse.ch'

    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      html_tag
    }

  end
end
