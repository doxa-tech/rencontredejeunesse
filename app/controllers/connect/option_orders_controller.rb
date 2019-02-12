class Connect::OptionOrdersController < Connect::BaseController

  def index
    @orders = current_user.option_orders
  end

  def show
    @order = current_user.option_orders.find(params[:id])
  end

  def destroy
    @order = current_user.option_orders.find(params[:id])
    if @order.order.unpaid? || @order.order.status.nil?
      @order.destroy
    end
    redirect_to new_option_order_path(@order.order_bundle.key), success: "Tu peux recommencer ta commande."
  end

end
