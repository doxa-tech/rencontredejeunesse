class Connect::VolunteersController < Connect::BaseController
  before_action(only: :confirmation) { end_of_order "03.05.2018" }

  def index
    @volunteers = current_user.volunteers
  end

  def show
    @volunteer = Volunteer.find(params[:id])
  end

end
