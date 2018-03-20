class Admin::VolunteersController < Admin::BaseController
  load_and_authorize

  def index
    @table = VolunteerTable.new(self, @volunteers, search: true)
    @table.respond
  end

  def edit
    @volunteer = Volunteer.find(params[:id])
  end

  def update
    @volunteer = Volunteer.find(params[:id])
    if @volunteer.update_attributes(volunteer_params)
      redirect_to admin_volunteers_path, success: "Bénévole mis à jour"
    else
      render 'edit'
    end
  end

  def destroy
    Volunteer.find(params[:id]).destroy
		redirect_to admin_volunteers_path, success: "Bénévole supprimé"
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:sector, :comment)
  end

end
