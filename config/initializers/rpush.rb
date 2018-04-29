Rpush.configure do |config|

  # Supported clients are :active_record and :redis
  config.client = :active_record

  # Options passed to Redis.new
  # config.redis_options = {}

  # Frequency in seconds to check for new notifications.
  config.push_poll = 2

  # The maximum number of notifications to load from the store every `push_poll` seconds.
  # If some notifications are still enqueued internally, Rpush will load the batch_size less
  # the number enqueued. An exception to this is if the service is able to receive multiple
  # notification payloads over the connection with a single write, such as APNs.
  config.batch_size = 100

  # Path to write PID file. Relative to current directory unless absolute.
  config.pid_file = 'tmp/rpush.pid'

  # Path to log file. Relative to current directory unless absolute.
  config.log_file = 'log/rpush.log'

  config.log_level = (defined?(Rails) && Rails.logger) ? Rails.logger.level : ::Logger::Severity::INFO

  # Define a custom logger.
  # config.logger = MyLogger.new

  # config.apns.feedback_receiver.enabled = true
  # config.apns.feedback_receiver.frequency = 60

end

Rpush.reflect do |on|

  # Called when the GCM returns a canonical registration ID.
  # You will need to replace old_id with canonical_id in your records.
  on.gcm_canonical_id do |old_id, canonical_id|
   # Example code if you have a Class 'Device' with an attribute 'registration_id':
   device = Device.find_by(token: old_id)
   device.update_attributes(token: canonical_id)
  end

  # Called when the GCM returns a failure that indicates an invalid registration id.
  # You will need to delete the registration_id from your records.
  on.gcm_invalid_registration_id do |app, error, registration_id|
    device = Device.find_by(token: registration_id)
    device.destroy if device
  end

end
