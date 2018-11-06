class OptionOrdersController < ApplicationController
  include SectorsHelper

  before_action :check_if_signed_in, only: :create
  before_action :check_if_signed_up, only: [:new, :create]

  def new
    @option_order = OptionOrder.new
  end

  def create
    @option_order = order_bundle.option_orders.new(option_order_params)
    @option_order.user = current_user
    @option_order.build_order(current_user, order_bundle.items.first)
    if @option_order.save
      VolunteerMailer.confirmation(@option_order).deliver_now
      redirect_to edit_orders_event_path(@option_order.order.order_id, item: order_bundle.key)
    else
      render "new"
    end
  end

  private

  def option_order_params
    params.require(:option_order).permit(:sector, :comment)
  end

  def check_if_signed_up
    option_order = OptionOrder.find_by(order_bundle: order_bundle, user: current_user) if current_user
    if option_order && option_order.order.status == "paid"
      redirect_to connect_option_order_path(option_order), error: "Tu es déjà inscrit !"
    elsif option_order
      redirect_to edit_orders_event_path(option_order.order.order_id, item: order_bundle.key), success: "Tu peux continuer ta commande."
    end
  end

  def order_bundle
    @order_bundle ||= OrderBundle.find(params[:order_bundle_id])
  end
end
