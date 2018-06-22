When(/^I complete the order form$/) do
  check "J'ai lu les conditions générales et les accepte."
  click_button "S'inscrire"
end

Then(/^I should see errors for the order form$/) do
  expect(page).to have_css(".error-message", text: "conditions")
end
