class Orders::RjController < Orders::BaseController

  def new
    @order = order
    @volunteer = VolunteerForm.new
  end

  def create
    @order = order(order_params)
    @volunteer = VolunteerForm.new(volunteer_params)
    if @order.save(context: :order)
      @volunteer.save(@order.user)
      redirect_to confirmation_orders_rj_path(@order.order_id)
    else
      render 'new'
    end
  end

  def edit
    @volunteer = VolunteerForm.find_by_user(@order.user)
  end

  def update
    @order.product = Records::Rj.new
    @volunteer = VolunteerForm.new(volunteer_params)
    @order.assign_attributes(order_params)
    if @order.save(context: :order)
      @volunteer.save(@order.user)
      redirect_to confirmation_orders_rj_path(@order.order_id)
    else
      render 'edit'
    end
  end

  def confirmation
    @volunteer = VolunteerForm.find_by_user(@order.user)
  end

  def invoice
    unless params[:document].nil?
      Orders::RjMailer.group_registration(@order).deliver_now
      Admin::Orders::RjMailer.group_registration(@order, params[:document].read).deliver_now
      @order.update_attribute(:status, 41)
      redirect_to orders_confirmed_path
    else
      redirect_to confirmation_orders_rj_path(@order.order_id), error: "Fichier d'inscription incorrect"
    end
  end

  private

  def order_params
    params.require(:order).permit(:conditions, :payment_method, user_attributes: [
      :firstname, :lastname, :email, :phone, :address, :npa, :city, :country, :newsletter, :birthday, :gender],
      product_attributes: [:group, :girl_beds, :boy_beds,
      participants_attributes: [:firstname, :lastname, :age, :_destroy]
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
