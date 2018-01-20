class Orders::LoginController < Orders::BaseController
  before_action :check_if_not_signed_in
  # @order fetched in before action #closed

  def new
    @order = order
  end

  def create
    @order = order(order_params)
    @order.pending = pending?
    if @order.save
      to_confirmation_step_or_pending
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @order.assign_attributes(order_params)
    @order.pending = pending?
    if @order.save
      to_confirmation_step_or_pending
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
