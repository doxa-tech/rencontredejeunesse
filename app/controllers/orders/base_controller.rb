class Orders::BaseController < ApplicationController
  include OrdersHelper

  before_action :closed, only: [:edit, :update, :confirmation, :complete]
  #before_action :end_from_order

  def check_if_not_signed_in
    redirect_to controller: "orders/users", action: :new, product: controller_name unless signed_in?
  end

  private

  # TODO
  def closed
    @order = Order.find_by_order_id(params[:id])
    redirect_to root_path, error: "Cette commande est déjà traitée." unless @order.status.nil?
  end

  def end_from_order
    redirect_to root_path, error: "Les commandes ne sont plus possibles." unless Rails.env.test?
  end

end
