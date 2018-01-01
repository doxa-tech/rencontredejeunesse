When("I successfully complete the signup form") do
  select "Homme", from: "Sexe"
  fill_in "Prénom", with: "Albert"
  fill_in "Nom de famille", with: "Dupont"
  fill_in "Email", with: "albert@dupont.com"
  fill_in "Téléphone", with: "1234567890"
  fill_in "Adresse", with: "Route de la fruitière 18"
  fill_in "NPA", with: "1291"
  fill_in "Ville", with: "Le Moulin"
  find(:select, "Pays").first(:option, "Suisse").select_option
  fill_in "Mot de passe", with: "12341"
  fill_in "Confirmation", with: "12341"
  click_button "Créer mon compte"
end
