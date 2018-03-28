class VolunteersController < ApplicationController
  include SectorsHelper

  before_action :check_if_signed_in, only: :create
  before_action :check_if_volunteer, only: :create

  def index
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(volunteer_params)
    @volunteer.user = current_user
    @volunteer.year = 2018 # TODO: use constant
    if @volunteer.save
      VolunteerMailer.confirmation(@volunteer).deliver_now
      redirect_to connect_volunteers_path, success: "Bienvenue chez nous !"
    else
      render "index"
    end
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:sector, :comment, :tshirt_size)
  end

  def check_if_volunteer
    redirect_to connect_volunteers_path if current_user.volunteer
  end
end
