Given("I am on the confirmation page with an amount of zero") do
  registrant = build(:registrant, item: @item, order: nil)
  @order = create(:event_order, user: @user, registrants: [registrant])
  @discount = create(:discount, category: :free, number: 1, items: [@item])
  @order.discount = @discount
  @order.save!
  visit confirmation_orders_event_path(@order.order_id, key: @item.order_bundle.key)
end

When("I fill in a valid discount") do
  @discount = create(:discount, category: :money)
  fill_in "Code promotionel", with: @discount.code
end

When("I fill in a invalid discount") do
  fill_in "Code promotionel", with: "FALS"
end

Then("I should see a discount") do
  price = (@item.price - @discount.reduction) / 100
  expect(find ".price").to have_content "#{price} CHF"
end

Then("I should see an error on the discount field") do
  expect(page).to have_css ".error-message", text: "Le code promotionel n'est pas valide"
end
