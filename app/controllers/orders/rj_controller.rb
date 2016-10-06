class Orders::RjController < ApplicationController

  def new
    @order = order
  end

  def create
    @order = order(order_params)
    if @order.save
      redirect_to confirmation_orders_rj_path(@order.order_id)
    else
      render 'new'
    end
  end

  def edit
    @order = Order.find_by_order_id(params[:id])
  end

  def update
    @order = Order.find_by_order_id(params[:id])
    @order.product = Records::Rj.new
    if @order.update_attributes(order_params)
      redirect_to confirmation_orders_rj_path(@order.order_id)
    else
      render 'edit'
    end
  end

  def confirmation
    @order = Order.find_by_order_id(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:conditions, user_attributes: [
      :firstname, :lastname, :email, :address, :npa, :city, :country, :newsletter], product_attributes: [
      :entries, :group, :girl_beds, :boy_beds
    ])
  end

  def order(params = {})
    order = Order.new
    order.user = User.new
    order.product = Records::Rj.new
    order.assign_attributes(params)
    return order
  end
end
