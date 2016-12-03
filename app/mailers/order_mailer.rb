class OrderMailer < ApplicationMailer
  default from: "Rencontre de Jeunesse <noreply@rencontredejeunesse.ch>"

  def confirmation(order)
    @order = order
    mail(to: order.user.email, subject: "Confirmation d'inscription", template_path: "order_mailer/#{order.product_type.underscore}")
  end

end
