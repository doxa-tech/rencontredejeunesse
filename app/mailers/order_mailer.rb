class OrderMailer < ApplicationMailer

  def confirmation(email, path)
    mail(to: email, subject: "Confirmation d'inscription", template_path: "order_mailer/#{path}")
  end
end
