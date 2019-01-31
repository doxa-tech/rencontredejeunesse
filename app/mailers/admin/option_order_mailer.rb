class Admin::OptionOrderMailer < ApplicationMailer

  def registration()
    mail(to: ["daniel.darcey@gmail.com", "raphael.guichoud@gmail.com", "kocher.ke@gmail.com"], subject: "Nouveau bénévole confirmé")
  end

end
