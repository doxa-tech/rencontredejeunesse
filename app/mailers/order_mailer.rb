class OrderMailer < ApplicationMailer

  def confirmation(user, path)
    mail(to: user, subject: "Confirmation d'inscription", template_path: "order_mail/#{path}")
  end
end
