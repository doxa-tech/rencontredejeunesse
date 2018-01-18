class Connect::OrdersController < Connect::BaseController

  def index
    @orders = current_user.completed_orders
  end

  def pending
  end

  def show
    @order = Order.find(params[:id])
  end
end
