class Admin::CheckinController < Admin::BaseController
  include OrdersHelper
  layout "checkin"

  def index
    authorize!
  end

  def show
    authorize!
    @order = Order.find_by!(order_id: params[:id])
    @state = "ok"
    if !@order.note.blank?
      @state = "infos"
    elsif @order.status != 9 || @order.delivered
      @state = "nok"
    end
  end

  # Look for the order
  def create
    authorize!
    p params[:order_id]
    @order = Order.find_by(order_id: params[:order_id])
    unless @order.nil?
      redirect_to admin_checkin_path(params[:order_id])
    else
      flash.now[:error] = "Commande non trouvée !"
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
