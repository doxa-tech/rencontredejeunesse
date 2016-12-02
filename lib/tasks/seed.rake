namespace :seed do

  desc "Setup the superuser"
  task superuser: :namespace do
    User.create!(
      firstname: "Keran",
      lastname: "Kocher",
      email: "kocher.ke@gmail.com",
      address: "Rue du château 26"
      npa: 1627,
      city: "Vaulruz",
      country: "CH",
      phone: "0774900897"
    )
  end

end
