class MainMailer < ApplicationMailer

  def contact(contact)
    @contact = contact
    mail(to: "info@rencontredejeunesse.ch", subject: "Formulaire de contact: #{@contact.subject}")
  end

end
