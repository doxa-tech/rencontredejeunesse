When("I fill in a free entry discount") do
  @discount = create(:discount, category: :free, number: 1)
  fill_in "Code promotionel", with: @discount.code
end

Then("I should see the volunteer confirmation page") do
    expect(find "h1").to have_content("Confirmation")
end

Then("I should see a discount on the volunteer price") do
  expect(find ".price").to have_content "0 CHF"
end
