When("I sign in") do
  within ".signin" do
    fill_in "Email", with: "john@smith.com"
    fill_in "Mot de passe", with: "carottes"
    click_button "Se connecter"
  end
end

Then("I should see the order page") do
  expect(page).not_to have_content "Se connecter"
end

Then("I should see the sign in and up page") do
  expect(page).to have_content "Se connecter"
  expect(page).to have_content "S'inscrire"
end
