class OrderMailer < ApplicationMailer
  default reply_to: "inscriptions@rencontredejeunesse.ch"
  helper OrdersHelper
  layout 'mailer'

  def confirmation(order)
    @order = order
    mail(to: order.user.email, subject: "Confirmation de commande")
  end

  def pass(order)
    @order = order
    # TODO
    # pdf = OrderPdf.new(@order.pdf_adapter)
    # attachments["Ticket_#{@order.order_id}.pdf"] = { :mime_type => 'application/pdf', :content => pdf.render }
    mail(to: order.user.email, subject: "Ticket pass pour ta commande")
  end

  def invoice_registration(order)
    @order = order
    mail(to: order.user.email, cc: ["kocher.ke@gmail.com"], subject: "Votre facture pour la commande #{@order.order_id}")
  end

  def reminder
    # TODO
    @event = ""
    emails = []
    mail(to: "Commandes <noreply@rencontredejeunesse.ch>", bcc: emails, subject: "Ta commande pour la RJ")
  end

end
