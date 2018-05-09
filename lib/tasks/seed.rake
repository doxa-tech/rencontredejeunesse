namespace :seed do

  desc "Setup the superuser"
  task superuser: :environment do
    user = User.create!(
      firstname: "Keran",
      lastname: "Kocher",
      email: "kocher.ke@gmail.com",
      address: "Rue du château 26",
      gender: "male",
      npa: 1627,
      city: "Vaulruz",
      country: "CH",
      phone: "+41774900897",
      birthday: Date.parse("15.02.1996"),
      password: "12341",
      password_confirmation: "12341"
    )
    puts "User created with id=#{user.id}"
  end

end
