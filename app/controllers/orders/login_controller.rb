class Orders::LoginController < Orders::BaseController
  before_action :check_if_not_signed_in

  def new
    @order = order
    @order.product.entries = 1
  end

  def create
    @order = order(order_params)
    if @order.save
      redirect_to confirmation_orders_login_path(@order.order_id)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @order.assign_attributes(order_params)
    if @order.save
      redirect_to confirmation_orders_login_path(@order.order_id)
    else
      render 'edit'
    end
  end

  def confirmation
  end

  private

  def order_params
    params.require(:order).permit(:conditions,
      product_attributes: [:id, :group,
      participants_attributes: [:id, :gender, :firstname, :lastname, :email, :age, :_destroy],
    ])
  end

  def order(params = {})
    order = Order.new
    order.user = current_user
    order.product = Records::Login.new
    order.assign_attributes(params)
    return order
  end
end
