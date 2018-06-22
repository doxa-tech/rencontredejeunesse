class Orders::BaseController < ApplicationController
  include OrdersHelper

  # TODO: method #order to fetch the order

  def check_if_not_signed_in
    redirect_to controller: "orders/users", action: :new, product: controller_name unless signed_in?
  end

  def pending?
    params[:pending].present?
  end

  def to_confirmation_step_or_pending
    if pending?
      redirect_to pending_connect_orders_path
    else
      redirect_to action: :confirmation, id: @order.order_id
    end
  end

  def closed
    @order = Orders::Event.find_by_order_id!(params[:id])
    redirect_to root_path, error: "Cette commande est déjà traitée." unless @order.main_payment.status.nil?
  end

  def not_pending
    # @order fetched in before_action #closed
    redirect_to root_path, error: "Cette commande est en cours." if @order.pending
  end

end
