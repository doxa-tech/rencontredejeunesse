class OptionOrderMailer < ApplicationMailer
  layout 'mailer'

  def confirmation(option_order)
    @option_order = option_order
    @completed_form = option_order.completed_form
    mail(to: option_order.user.email, subject: "Merci pour ton inscription !")
  end

end
