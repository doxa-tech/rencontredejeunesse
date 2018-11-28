class MainMailer < ApplicationMailer

  def contact(contact)
    @contact = contact
    mail(to: contact_email, subject: "Formulaire de contact: #{@contact.subject}", reply_to: @contact.email)
  end

  def remove_accounts
    emails = User.where(address: nil).pluck(:email)
    mail(to: "Rencontredejeunesse <noreply@rencontredejeunesse.ch>", bcc: emails, subject: "Mise à jour obligatoire du compte RJ", reply_to: 'we@jstech.ch') do |format|
      format.html { render layout: "mailer" }
    end
  end

  private

  def contact_email
    Rails.env.production? ? "info@rencontredejeunesse.ch" : "kocher.ke@gmail.com"
  end

end
