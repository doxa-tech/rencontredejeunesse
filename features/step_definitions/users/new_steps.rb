When("I successfully complete the signup form") do
  within ".signup" do
    select "Homme", from: "Sexe"
    fill_in "Prénom", with: "John"
    fill_in "Nom de famille", with: "Smith"
    fill_in "Email", with: "john@smith.com"
    fill_in "Téléphone", with: "1234567890"
    fill_in "Adresse", with: "Route de la fruitière 18"
    fill_in "NPA", with: "1291"
    fill_in "Ville", with: "Le Moulin"
    find(:select, "Pays").first(:option, "Suisse").select_option
    fill_in "Mot de passe", with: "carottes"
    fill_in "Confirmation", with: "carottes"
    click_button "Créer mon compte"
  end
end
