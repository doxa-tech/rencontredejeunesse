Given("I have a pending order") do
  @order = create(:order, pending: true, user: @user)
end

When("I complete the Login form without submiting it") do
  check "J'ai lu les conditions générales et les accepte."
end

Then("I should see my pending order") do
  pending_order = Order.last
  expect(page).to have_content "Commandes en cours"
  expect(page).to have_content pending_order.order_id unless pending_order.nil?
end

Then("I should not see my pending order") do
  pending_order = Order.last
  expect(page).not_to have_content pending_order.order_id unless pending_order.nil?
end

Then("I should see the page to edit my order") do
  expect(page).to have_content "Inscription"
end
