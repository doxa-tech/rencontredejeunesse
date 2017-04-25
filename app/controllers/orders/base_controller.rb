class Orders::BaseController < ApplicationController
  include OrdersHelper

  before_action :closed, only: [:edit, :update, :confirmation, :invoice]
  #before_action :end_from_order

  private

  def closed
    @order = Order.find_by_order_id(params[:id])
    redirect_to root_path, error: "Cette commande est déjà traitée." unless @order.status.nil?
  end

  def end_from_order
    redirect_to root_path, error: "Les commandes ne sont plus possibles." unless Rails.env.test?
  end

end
