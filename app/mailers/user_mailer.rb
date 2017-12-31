class UserMailer < ApplicationMailer

  def confirmation(user)
    @user = user
    mail(to: user.email, subject: "Confirmation de votre email")
  end
end
