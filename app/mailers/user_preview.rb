class UserPreview < ActionMailer::Preview
  def confirmation
    user = User.last
    UserMailer.confirmation(user)
  end
end

