class Orders::RjController < ApplicationController

  def new
    @order = nil
  end

  def create
    redirect_to confirmation_orders_rj_path
  end

  def confirmation
  end
end
