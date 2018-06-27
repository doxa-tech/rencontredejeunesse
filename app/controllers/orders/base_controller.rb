class Orders::BaseController < ApplicationController
  include OrdersHelper

  def check_if_not_signed_in
    redirect_to new_orders_user_path(item: params[:item]) unless signed_in?
  end

  def pending?
    params[:pending].present?
  end

  def to_confirmation_step_or_pending
    if pending?
      redirect_to pending_connect_orders_path
    else
      redirect_to action: :confirmation, id: order.order_id
    end
  end

  def closed
    redirect_to root_path, error: "Cette commande est déjà traitée." unless order.main_payment.status.nil?
  end

  def not_pending
    redirect_to root_path, error: "Cette commande est en cours." if order.pending
  end

  def order
    if @order.nil?
      @order = Orders::Event.find_by_order_id!(params[:id])
      @order = @order.becomes(Orders::Event) if params[:controller] == "orders/events"
    end
    return @order
  end

end
