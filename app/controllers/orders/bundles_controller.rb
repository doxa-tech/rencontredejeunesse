class Orders::BundlesController < Orders::BaseController
  before_action :check_if_not_signed_in
  before_action :closed, only: [:edit, :update, :confirmation]
  before_action :not_pending, only: :confirmation

  def edit
    @order_bundle = OrderBundle.find_by(key: params[:key])
    default_items = @order_bundle.items.map{ |i| [i.id, name: i.name, quantity: 0] }.to_h
    existing_items = order.order_items.map{ |i| [i.item_id, name: i.name, quantity: i.quantity]}.to_h
    @order_items = default_items.merge(existing_items)
  end

  def update
    @order_bundle = OrderBundle.find_by(key: params[:key])
    @order_bundle.items.each do |i| 
      quantity = params.dig(:order, :items, i.id.to_s, :quantity).to_i
      order.order_items.build(item: i, quantity: quantity) if quantity > 0
    end
    order.pending = pending?
    if order.save
      to_confirmation_step_or_pending
    else
      render 'edit'
    end
  end

  def confirmation
    @order_items = order.order_items.includes(:item)
  end

end