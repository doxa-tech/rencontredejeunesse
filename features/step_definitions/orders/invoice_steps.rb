Given("I am on the confirmation page with a payment by invoice") do
  @order = create(:event_order, user: @user)
  @item = create(:item_with_bundle, price: 10000)
  @order.registrants = create_list(:registrant, 10, order: @order, item: @item)
  @order.save!
  visit confirmation_orders_event_path(@order.order_id, key: @item.order_bundle.key)
end
