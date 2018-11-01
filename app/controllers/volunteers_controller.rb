class VolunteersController < ApplicationController
  include SectorsHelper

  before_action :check_if_signed_in, only: :create
  before_action :check_if_volunteer, only: [:new, :create]

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = @volunteering.volunteers.new(volunteer_params)
    @volunteer.user = current_user
    @volunteer.build_order(current_user, @volunteering.item)
    if @volunteer.save
      VolunteerMailer.confirmation(@volunteer).deliver_now
      redirect_to confirmation_orders_event_path(@volunteer.order.order_id)
    else
      render "new"
    end
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:sector, :comment)
  end

  def check_if_volunteer
    @volunteering = Volunteering.find(params[:volunteering_id])
    if current_user && volunteer = Volunteer.find_by(volunteering: @volunteering, user: current_user)
      redirect_to connect_volunteer_path(volunteer), error: "Tu es déjà inscrit comme bénévole."
    end
  end
end
