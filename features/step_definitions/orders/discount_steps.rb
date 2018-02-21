When("I fill in a valid discount") do
  @discount = create(:discount, category: :money, reduction: 20)
  fill_in "Code promotionel", with: @discount.code
end

Then("I should see a discount") do
  price = Records::Rj.ENTRY_PRICE + Records::Rj::LODGING_PRICE + Records::Rj::FEE - @discount.reduction
  expect(find ".price").to have_content "#{price} CHF"
end
