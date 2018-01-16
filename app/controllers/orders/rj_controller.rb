class Orders::RjController < Orders::BaseController

  def new
    @order = order
  end

  def create
    @order = order(order_params)
    if @order.save
      redirect_to confirmation_orders_rj_path(@order.order_id)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @order.assign_attributes(order_params)
    if @order.save
      redirect_to confirmation_orders_rj_path(@order.order_id)
    else
      render 'edit'
    end
  end

  def confirmation
  end

  private

  def order_params
    params.require(:order).permit(:conditions, :payment_method, user_attributes: [
      :id, :firstname, :lastname, :email, :phone, :address, :npa, :city, :country, :newsletter, :birthday, :gender],
      product_attributes: [:id, :group, :girl_beds, :boy_beds,
      participants_attributes: [:id, :firstname, :lastname, :age, :_destroy]
    ])
  end

  def order(params = {})
    order = Order.new
    order.user = current_user
    order.product = Records::Rj.new
    order.assign_attributes(params)
    return order
  end
end
