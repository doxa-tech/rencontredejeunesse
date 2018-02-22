When("I fill in a valid discount") do
  @discount = create(:discount, category: :money)
  fill_in "Code promotionel", with: @discount.code
end

When("I fill in a invalid discount") do
  fill_in "Code promotionel", with: "FALS"
end


Then("I should see a discount") do
  price = Records::Rj.ENTRY_PRICE + Records::Rj::LODGING_PRICE + Records::Rj::FEE - @discount.reduction / 100
  expect(find ".price").to have_content "#{price} CHF"
end

Then("I should see an error on the discount field") do
  expect(page).to have_css ".error-message", text: "Le code promotionel n'est pas valide"
end
