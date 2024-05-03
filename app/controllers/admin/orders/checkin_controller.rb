class Admin::Orders::CheckinController < Admin::BaseController
  include OrdersHelper
  layout "checkin"

  def index
    authorize!
  end

  # Look for the order
  def create
    authorize!
    @registrant = Registrant.find_by(ticket_id: params[:ticket_id])
    unless @registrant.nil?
      redirect_to admin_orders_registrant_path(id: @registrant.id)
    else
      flash.now[:error] = "Commande non trouvée !"
      render 'index'
    end
  end

  # Deliver the order
  def update
    authorize!

    @registrant = Registrant.find_by(ticket_id: params[:id])
    @registrant.update_attribute(:delivered, true)
    # notify
    order = @registrant.order
    if !order.paid? || order.delivered?
      OrderMailer.anomalous_delivery(order).deliver_now
    end
    redirect_to admin_orders_checkin_index_path, success: "Livré"
  end

end
