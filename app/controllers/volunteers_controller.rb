class VolunteersController < ApplicationController
  include SectorsHelper

  # TODO
  # before_action :check_if_signed_in, only: :create
  # before_action :check_if_volunteer, only: :create

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteering = Volunteering.find(params[:volunteering_id])
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
    redirect_to connect_volunteers_path if current_user.volunteer
  end
end
