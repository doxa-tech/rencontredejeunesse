class MainMailer < ApplicationMailer

  def contact(contact)
    @contact = contact
    mail(to: @contact.contact_email, subject: "Formulaire de contact: #{@contact.subject}", reply_to: @contact.email)
  end

end
