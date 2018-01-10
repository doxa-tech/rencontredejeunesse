class UserMailer < ApplicationMailer
  layout 'mailer'

  def confirmation(user)
    @user = user
    mail(to: user.email, subject: "Confirmation de votre email")
  end

  def password_reset(user)
    @user = user
    mail(to: user.email, subject: "Réinitialisation de votre mot de passe RJ Connect'")
  end
end
