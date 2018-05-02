class Admin::CheckinController < Admin::BaseController
  include OrdersHelper
  layout "checkin"

  def index
    authorize!
  end

  def show
    authorize!
    @order = Order.find_by!(order_id: params[:id])
  end

  # Look for the order
  def create
    authorize!
    @order = Order.find_by(order_id: params[:order_id])
    unless @order.nil?
      redirect_to admin_checkin_path(params[:order_id])
    else
      flash.now[:error] = "Commande non trouvé !"
      render 'index'
    end
  end

  # Deliver the order
  def update
    authorize!
    @order = Order.find_by!(order_id: params[:id])
    @order.update_attribute(:delivered, true)
    redirect_to admin_checkin_index_path, success: "Livré"
  end

end
