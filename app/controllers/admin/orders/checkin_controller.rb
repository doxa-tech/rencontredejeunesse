class Admin::Orders::CheckinController < Admin::BaseController
  include OrdersHelper
  layout "checkin"

  def index
    authorize!
  end

  # Look for the order
  def create
    authorize!
    @order = Order.find_by(order_id: params[:order_id])
    unless @order.nil?
      redirect_to admin_orders_event_path(@order)
    else
      flash.now[:error] = "Commande non trouvée !"
      render 'index'
    end
  end

  # Deliver the order
  def update
    authorize!
    @order = Order.find(params[:id])
    @order.update_attributes(status: "delivered")
    redirect_to admin_orders_checkin_index_path, success: "Livré"
  end

  private

end
