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
    other = Volunteer.find_or_create_by!(other: self.other, comment: self.comment) if self.other.present?
    volunteers = VolunteerForm.sectors.map do |sector|
      Volunteer.find_or_create_by!(sector: sector, comment: self.comment) if send(sector) == "1"
    end << other
    user.volunteers = volunteers.compact
  end

  def self.find_by_user(user)
    params = user.volunteers.pluck(:sector, :comment, :other).map do |sector, comment, other|
      @comment ||= comment
      other.nil? ? [sector.to_sym, "1"] : [:other, other]
    end.to_h
    VolunteerForm.new(**params.merge(comment: @comment))
  end

  def selected
    VolunteerForm.sectors.map do |sector|
      I18n.t("activemodel.attributes.volunteer_form.#{sector}") if send(sector) == "1"
    end.compact.join(", ")
  end

end
