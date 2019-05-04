module PushNotifications

  def send_push_notifications(message)
    app = Rpush::Gcm::App.find_by_name("RJ")
    Device.find_in_batches do |devices|
      n = Rpush::Gcm::Notification.new
      n.app = app
      n.registration_ids = devices.pluck(:token)
      n.notification = { body: message }
      n.save!
    end
    Rpush.push
    Rpush.apns_feedback
  end

end