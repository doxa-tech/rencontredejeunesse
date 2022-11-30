Sentry.init do |config|
  config.dsn = 'https://7a554950d6e54553bb5838b370498d6a:047ab51a9197432b9829847da5c1d3e7@sentry.io/140467'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end