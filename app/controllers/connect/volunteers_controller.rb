class Connect::VolunteersController < ApplicationController
  layout 'connect'

  def index
    @volunteer = current_user.volunteer
  end

end
