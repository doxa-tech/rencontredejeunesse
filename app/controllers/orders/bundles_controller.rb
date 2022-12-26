class Orders::BundlesController < Orders::BaseController
  before_action :check_if_not_signed_in
  before_action :closed, only: [:edit, :update, :confirmation]
  before_action :not_pending, only: :confirmation

  def new
    if OrderBundle.where(key: params[:key]).exists?
      order = Order.create!(user: current_user)
      redirect_to edit_orders_bundle_path(order.order_id, key: params[:key])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def edit
    @order_bundle = OrderBundle.find_by!(key: params[:key])
    default_items = @order_bundle.items.map{ |i| [i.id, name: i.name, quantity: 0] }.to_h
    existing_items = order.order_items.includes(:item).map{ |i| [i.item_id, name: i.item.name, quantity: i.quantity]}.to_h
    @order_items = default_items.merge(existing_items)
  end

  def update
    @order_bundle = OrderBundle.find_by!(key: params[:key])
    order.pending = pending?
    update_items(order, bundle: @order_bundle)
    order.save! # to update the amount
    to_confirmation_step_or_pending
  end

  def confirmation
    @order_items = order.order_items.includes(:item)
  end

  private

  def update_items(order, bundle:)
    order_items = bundle.items.map do |i|
      quantity = params.dig(:order, :items, i.id.to_s, :quantity).to_i
      OrderItem.new(order: order, item: i, quantity: quantity) if quantity > 0
    end
    # persist the change to the db
    order.order_items = order_items
  end

end