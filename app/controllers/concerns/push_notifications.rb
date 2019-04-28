module PushNotifications

  def send_push_notifications(message)
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name("RJ")
    n.registration_ids = Device.pluck(:token)
    n.notification = { body: message }
    n.save!
    Rpush.push
    Rpush.apns_feedback
  end

end