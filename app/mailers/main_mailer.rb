class MainMailer < ApplicationMailer

  def contact(contact)
    @contact = contact
    mail(to: "kocher.ke@gmail.com", subject: "Formulaire de contact: #{@contact.subject}")
  end

end
