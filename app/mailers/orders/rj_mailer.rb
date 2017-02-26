class Orders::RjMailer < ApplicationMailer
  layout 'mailer'

  def group_registration(order)
    @order = order
    mail(to: order.user.email, subject: "Inscription de groupe à la Rencontre de jeunesse")
  end
end
