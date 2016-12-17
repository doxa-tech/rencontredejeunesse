When(/^I complete the RJ form$/) do
  fill_in "Nombre de forfaits", with: "2"
  step "I complete the order form"
end

When(/^I miscomplete the RJ update form$/) do
  fill_in "Nombre de forfaits", with: ""
  fill_in "Prénom", with: ""
  click_button "Mettre à jour"
end

Then(/^I should see errors for the RJ form$/) do
  expect(find "#error").to have_content("Nombre de forfaits")
  step "I should see errors for the order form"
end
