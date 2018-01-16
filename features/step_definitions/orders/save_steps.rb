Then("I should see my pending order") do
  expect(page).to have_content "Commandes en cours"
  expect(page).to have_content Order.last.order_id
end
