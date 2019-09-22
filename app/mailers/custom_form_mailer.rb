class CustomFormMailer < ApplicationMailer

  def confirmation(email, completed_form)
    @form = completed_form
    mail(to: email, subject: "Confirmation d'envoi du formulaire")
  end

end
