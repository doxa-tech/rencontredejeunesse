namespace :seed do

  desc "Setup the superuser"
  task superuser: :environment do
    User.create!(
      firstname: "Keran",
      lastname: "Kocher",
      email: "kocher.ke@gmail.com",
      address: "Rue du château 26",
      npa: 1627,
      city: "Vaulruz",
      country: "CH",
      phone: "0774900897",
      password: "12341",
      password_confirmation: "12341"
    )
  end

end
