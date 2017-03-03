class Admin::Orders::RjMailer < ApplicationMailer
  layout 'mailer'

  def group_registration(order, file)
    @order = order
    attachments["inscription_#{@order.user.firstname}_#{@order.user.lastname}.xls"] = file
    mail(to: ["emilieraby@donagencement.ch", "kocher.ke@gmail.com"], subject: "Demande d'inscription de groupe à la RJ")
  end
end
