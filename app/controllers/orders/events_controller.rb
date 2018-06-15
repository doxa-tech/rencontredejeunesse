class Orders::EventsController < Orders::BaseController
  before_action :check_if_not_signed_in
  before_action :closed, only: [:edit, :update, :confirmation]
  before_action :not_pending, only: :confirmation

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
    params.require(:order).permit(:conditions, :discount_code,
      product_attributes: [:id, :group,
      participants_attributes: [:id, :gender, :firstname, :lastname, :birthday, :lodging, :_destroy]
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
