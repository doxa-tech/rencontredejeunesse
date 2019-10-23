class OptionOrdersController < ApplicationController

  before_action :check_if_signed_in, only: :create
  before_action :check_if_signed_up, only: [:new, :create]

  def new
    @custom_form = CustomForm.new(form, option_orders_path, view_context)
  end

  def create
    @custom_form = CustomForm.new(form, option_orders_path, view_context)
    @custom_form.assign_attributes(params[:custom_form])
    if @custom_form.save
      option_order = OptionOrder.new(user: current_user, order_bundle: @order_bundle, completed_form: @custom_form.completed_form)
      option_order.build_order(current_user, order_bundle.items.first)
      option_order.save!
      OptionOrderMailer.confirmation(option_order).deliver_now
      redirect_to edit_orders_event_path(option_order.order.order_id, key: order_bundle.key)
    else
      render "new"
    end
  end

  private

  def check_if_signed_up
    option_order = OptionOrder.find_by(order_bundle: order_bundle, user: current_user) if current_user
    if option_order && option_order.order.status.present?
      redirect_to connect_option_order_path(option_order), error: "Tu es déjà inscrit !"
    elsif option_order
      redirect_to edit_orders_event_path(option_order.order.order_id, key: order_bundle.key), success: "Tu peux continuer ta commande."
    end
  end

  def order_bundle
    # What if no bundle found ? TODO
    @order_bundle ||= OrderBundle.find_by(key: params[:key])
  end

  def form
    @form ||= order_bundle.form
  end

end
