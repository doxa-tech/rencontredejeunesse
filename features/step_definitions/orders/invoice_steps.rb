Given("I am on the confirmation page with a payment by invoice") do
  participants = build_list(:rj_participant, 15, lodging: true)
  product = create(:rj, participants: participants)
  @order = create(:order, user: @user, product: product)
  visit confirmation_orders_rj_path(@order.order_id)
end
