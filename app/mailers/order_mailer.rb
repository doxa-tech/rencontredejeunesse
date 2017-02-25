class OrderMailer < ApplicationMailer
  helper OrdersHelper
  layout 'mailer'

  def confirmation(order)
    @order = order
    mail(to: order.user.email, subject: "Confirmation d'inscription", template_path: "order_mailer/#{order.product_type.underscore}")
  end

  def invoice_for_rj(order)
    @order = order
    @order.update_attribute(:status, 41)
    attachments['inscription.xlsx'] = File.read("#{Rails.root}/app/assets/documents/inscription.xlsx")
    mail(to: order.user.email, subject: "Inscription de groupe à la Rencontre de jeunesse",
      template_path: "order_mailer/records/rj", template_name: "invoice")
  end

end
