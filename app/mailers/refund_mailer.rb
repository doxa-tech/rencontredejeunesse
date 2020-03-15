class RefundMailer < ApplicationMailer
  layout 'mailer'
  
  def confirmation(refund)
    @refund = refund
    mail(to: refund.user.email, subject: "Confirmation de votre demande")
  end

end
