class Admin::OrderMailer < ApplicationMailer
  layout 'mailer'

  def invoice_registration(order)
    @order = order
    mail(to: ["emilieraby@donagencement.ch", "kocher.ke@gmail.com"], subject: "Inscription sur facture sur rencontredejeunesse.ch")
  end

end
