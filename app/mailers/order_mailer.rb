class OrderMailer < ApplicationMailer
  helper OrdersHelper
  layout 'mailer'

  def confirmation(order)
    @order = order
    mail(to: order.user.email, subject: "Confirmation d'inscription", template_path: "order_mailer/#{order.product_type.underscore}")
  end

end

class OrderPreview < ActionMailer::Preview
  def confirmation
    order = Order.last
    OrderMailer.confirmation(order)
  end
end
