class VolunteerMailer < ApplicationMailer
  layout 'mailer'

  def confirmation(volunteer)
    @volunteer = volunteer
    mail(to: volunteer.user.email, subject: "Merci pour votre engagement !")
  end

  def order_opened
    emails = Volunteer.includes(:user).map { |v| v.user.email }
    mail(to: "Bénévoles <noreply@rencontredejeunesse.ch>", bcc: emails, subject: "Commande ton entrée comme bénévole !")
  end

end
