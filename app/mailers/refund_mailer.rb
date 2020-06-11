class RefundMailer < ApplicationMailer
  layout 'mailer'
  
  def confirmation(refund)
    @refund = refund
    mail(to: refund.user.email, subject: "Confirmation de votre demande")
  end

  def announcement(emails)
    mail(to: "Commandes <noreply@rencontredejeunesse.ch>", bcc: emails << "kocher.ke@gmail.com", subject: "Politique de remboursement de la RJ 2020")
  end

  def give(emails) 
    mail(to: "Commandes <noreply@rencontredejeunesse.ch>", bcc: emails << "kocher.ke@gmail.com", subject: "Annulation RJ 2020 - Faire un don")
  end

  def done(emails)
    mail(to: "Commandes <noreply@rencontredejeunesse.ch>", bcc: emails << "kocher.ke@gmail.com", subject: "Ton remboursement de la RJ 2020")
  end

end
