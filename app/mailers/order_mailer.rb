class OrderMailer < ApplicationMailer
  default reply_to: "billetterie@rencontredejeunesse.ch"
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
    mail(to: order.user.email, bcc: ["kocher.ke@gmail.com"], subject: "Votre facture pour la commande #{@order.order_id}")
  end

  def announcement(emails)
    mail(to: "Commandes <noreply@rencontredejeunesse.ch>", bcc: emails << "kocher.ke@gmail.com", subject: "Annulation de la Rencontre de Jeunesse")
  end

  # def emails_from_order(keys)
  #   User.joins(orders: [registrants: [item: :order_bundle]]).where(
  #     orders: { status: :paid, 
  #       registrants: { items: { order_bundles: { key: keys }}}
  #     }
  #   ).distinct.pluck(:email)
  # end

end
