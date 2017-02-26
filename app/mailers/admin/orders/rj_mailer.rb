class Admin::Orders::RjMailer < ApplicationMailer
  layout 'mailer'

  def group_registration(order, file)
    @order = order
    attachments['inscription.xlsx'] = file
    mail(to: ["inscription@rencontredejeunesse.ch", "kocher.ke@gmail.com"], subject: "Demande d'inscription de groupe à la RJ")
  end
end
