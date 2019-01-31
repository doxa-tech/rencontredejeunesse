class Admin::OptionOrderPreview < ActionMailer::Preview

  def registration
    Admin::OptionOrderMailer.registration()
  end

end
