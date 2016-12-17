class Orders::RjController < Orders::BaseController
  http_basic_authenticate_with name: "rj", password: Rails.application.secrets.basic_pwd if Rails.env.production?

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
end
