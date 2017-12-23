class MainMailer < ApplicationMailer

  def contact(contact)
    @contact = contact
    mail(to: contact_email, subject: "Formulaire de contact: #{@contact.subject}", reply_to: @contact.email)
  end

  private

  def contact_email
    Rails.env.production? ? "info@rencontredejeunesse.ch" : "kocher.ke@gmail.com"
  end

end
