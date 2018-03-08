class Orders::BaseController < ApplicationController
  include OrdersHelper

  # TODO: method #order to fetch the order

  before_action :closed, only: [:edit, :update, :confirmation, :complete]
  before_action :not_pending, only: [:confirmation, :complete]
  #before_action :end_of_order

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

  private

  def closed
    @order = Order.find_by_order_id!(params[:id])
    redirect_to root_path, error: "Cette commande est déjà traitée." unless @order.status.nil?
  end

  def not_pending
    # @order fetched in before_action #closed
    redirect_to root_path, error: "Cette commande est en cours." if @order.pending
  end

  def end_of_order
    redirect_to root_path, error: "Les commandes ne sont plus possibles." unless Rails.env.test?
  end

end
