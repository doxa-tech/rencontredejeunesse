class Admin::VolunteerMailer < ApplicationMailer
  layout 'mailer'

  def confirmed(volunteer)
    @volunteer = volunteer
    mail(to: ["daniel.darcey@gmail.com", "raphael.guichoud@gmail.com", "kocher.ke@gmail.com"], subject: "Nouveau bénévole confirmé")
  end

end
