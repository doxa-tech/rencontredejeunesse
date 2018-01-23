When("I complete the volunteer form") do
  select "Animation", from: "Domaine"
  select "Fun Park", from: "Secteur"
  fill_in "Remarque", with: "J'ai déjà un contact avec Alfred Dupont."
  click_button "S'inscrire"
end
