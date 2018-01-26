class Connect::VolunteersController < Connect::BaseController

  def index
    @volunteer = current_user.volunteer
  end

end
