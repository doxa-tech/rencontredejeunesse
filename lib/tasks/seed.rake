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

  desc "Initialize adeia elements"
  task adeia_elements: :environment do
    ENV['elements'] = "api/comments, api/users, api/testimonies, api/posts, admin/volunteers, admin/discounts, admin/orders/events, admin/users, admin/payments, admin/orders/checkin"
    Rake::Task["adeia:permissions"].invoke
  end

end
