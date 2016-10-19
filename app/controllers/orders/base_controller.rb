class Orders::BaseController < ApplicationController
  before_action :closed, only: [:edit, :update, :confirmation]

  private

  def closed
    @order = Order.find_by_order_id(params[:id])
    redirect_to root_path, error: "Cette commande est déjà traitée." unless @order.status.nil?
  end

end
