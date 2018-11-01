class VolunteerMailer < ApplicationMailer
  layout 'mailer'

  def confirmation(volunteer)
    @volunteer = volunteer
    mail(to: volunteer.user.email, subject: "Merci pour votre engagement !")
  end

end
