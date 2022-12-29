Given("I have an order with a pending payment") do
  @order = create(:event_order, user: @user)
  create(:payment, order: @order, amount: @order.amount, state: :fulfill) # main payment
  @payment = create(:payment, amount: 1000, order: @order, payment_type: :addition, state: :pending)
end

When("I visit the order summary") do
  visit connect_order_path(@order.order_id)
end

Then("I should see a confirmation page with the amount") do
  expect(page).to have_content("#{@payment.amount / 100} CHF")
end

Then("I should see the postfinance page") do
  expect(page).to have_content("#{@payment.amount / 100},00 CHF")
end