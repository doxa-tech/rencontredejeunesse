class Admin::OrderMailer < ApplicationMailer
  helper OrdersHelper
  layout 'mailer'

  def invoice_registration(order)
    @order = order
    mail(to: ["emilieraby@donagencement.ch", "kocher.ke@gmail.com"], subject: "Inscription sur facture sur rencontredejeunesse.ch")
  end

end
