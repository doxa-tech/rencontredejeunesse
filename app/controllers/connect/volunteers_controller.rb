class Connect::VolunteersController < ApplicationController

  def index
    @volunteer = current_user.volunteer
  end

end
