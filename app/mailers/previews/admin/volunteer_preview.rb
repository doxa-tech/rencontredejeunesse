class Admin::VolunteerPreview < ActionMailer::Preview

  def confirmed
    volunteer = Volunteer.last
    Admin::VolunteerMailer.confirmed(volunteer)
  end

end
