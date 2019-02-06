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
    pdf = TicketPdf.new(@order.ticket_pdf_adapter)
    attachments["Tickets_#{@order.order_id}.pdf"] = { :mime_type => 'application/pdf', :content => pdf.render }
    mail(to: order.user.email, subject: "Pass pour ta commande")
  end

  def invoice_registration(order)
    @order = order
    pdf = InvoicePdf.new(@order.invoice_pdf_adapter)
    attachments["Facture_#{@order.order_id}.pdf"] = { :mime_type => 'application/pdf', :content => pdf.render }
    mail(to: order.user.email, bcc: ["kocher.ke@gmail.com", "mchristen@hotmail.ch"], subject: "Votre facture pour la commande #{@order.order_id}")
  end

  def reminder
    # TODO
    @event = ""
    emails = []
    mail(to: "Commandes <noreply@rencontredejeunesse.ch>", bcc: emails, subject: "Ta commande pour la RJ")
  end

end
