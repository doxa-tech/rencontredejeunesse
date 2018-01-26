class VolunteerPreview < ActionMailer::Preview
  def confirmation
    volunteer = Volunteer.last
    VolunteerMailer.confirmation(volunteer)
  end
end
