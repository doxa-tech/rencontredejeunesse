class VolunteerMailer < ApplicationMailer
  layout 'mailer'

  def confirmation(volunteer)
    @volunteer = volunteer
    puts "MAIL"
    puts volunteer.user.email
    mail(to: volunteer.user.email, subject: "Merci pour votre engagement !")
  end

end
