Given("I have an order with a pending payment") do
  @order = create(:event_order, user: @user)
  @payment = create(:payment, order: @order, payment_type: :addition, status: 41)
end

When("I visit the order summary") do
  visit connect_order_path(@order.order_id)
end

Then("I should see a confirmation page with the amount") do
  expect(page).to have_content("#{@payment.amount / 100} CHF")
end

Then("I should see the postfinance page") do
  expect(page).to have_content(@payment.payment_id)
  expect(page).to have_content("#{@payment.amount / 100}.00 CHF")
end