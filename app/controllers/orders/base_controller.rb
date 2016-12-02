class Orders::BaseController < ApplicationController
  http_basic_authenticate_with name: "rj", password: Rails.application.secrets.basic_pwd, except: :index

  include OrdersHelper

  before_action :closed, only: [:edit, :update, :confirmation]

  private

  def closed
    @order = Order.find_by_order_id(params[:id])
    redirect_to root_path, error: "Cette commande est déjà traitée." unless @order.status.nil?
  end

end
