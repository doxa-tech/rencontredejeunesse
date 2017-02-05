class VolunteerForm
  #
  # Params structure
  # "volunteer_form" => { "door"=>"1", "install"=>"0", "other"=>"", "comment"=>"" }
  #

  include ActiveModel::Model

  def self.sectors
    return Volunteer.sectors.keys
  end

  attr_accessor *sectors, :other, :comment

  def save(user)
    Volunteer.find_or_create_by!(other: self.other, comment: self.comment, user: user) if self.other.present?
    VolunteerForm.sectors.each do |sector|
      Volunteer.find_or_create_by!(sector: sector, comment: self.comment, user: user) if send(sector) == "1"
    end
  end

  def selected
    VolunteerForm.sectors.map do |sector|
      I18n.t("activemodel.attributes.volunteer_form.#{sector}") if send(sector) == "1"
    end.compact.join(", ")
  end

end
