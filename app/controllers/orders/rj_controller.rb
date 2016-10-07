class Orders::RjController < ApplicationController
  before_action :closed, only: [:edit, :update]

  def new
    @order = order
    @volunteer = VolunteerForm.new
  end

  def create
    @order = order(order_params)
    @volunteer = VolunteerForm.new(volunteer_params)
    if @order.save
      session[:volunteer_params] = volunteer_params
      redirect_to confirmation_orders_rj_path(@order.order_id)
    else
      render 'new'
    end
  end

  def edit
    @volunteer = VolunteerForm.new(session[:volunteer_params])
  end

  def update
    @order.product = Records::Rj.new
    @volunteer = VolunteerForm.new(volunteer_params)
    if @order.update_attributes(order_params)
      session[:volunteer_params] = volunteer_params
      redirect_to confirmation_orders_rj_path(@order.order_id)
    else
      render 'edit'
    end
  end

  def confirmation
    @order = Order.find_by_order_id(params[:id])
    @volunteer = VolunteerForm.new(session[:volunteer_params])
  end

  private

  def order_params
    params.require(:order).permit(:conditions, user_attributes: [
      :firstname, :lastname, :email, :phone, :address, :npa, :city, :country, :newsletter], product_attributes: [
      :entries, :group, :girl_beds, :boy_beds
    ])
  end

  def volunteer_params
    params.require(:volunteer_form).permit(:comment, :other, *Volunteer.sectors)
  end

  def order(params = {})
    order = Order.new
    order.user = User.new
    order.product = Records::Rj.new
    order.assign_attributes(params)
    return order
  end

  def closed
    @order = Order.find_by_order_id(params[:id])
    redirect_to root_path, error: "Cette commande est déjà traitée." unless @order.status.nil?
  end
end
