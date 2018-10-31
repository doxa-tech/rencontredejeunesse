class VolunteeringController < ApplicationController

  def index
    @volunteering = Volunteering.find_by(key: "rj2019")
  end

end
