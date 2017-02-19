Raven.configure do |config|
  config.dsn = 'https://7a554950d6e54553bb5838b370498d6a:047ab51a9197432b9829847da5c1d3e7@sentry.io/140467'

  config.environments = ['production']

  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
