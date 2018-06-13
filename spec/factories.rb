FactoryBot.define do

  factory :user do
    firstname "John"
    lastname "Smith"
    email { "#{firstname.downcase}@#{lastname.downcase}.com" }
    address "Route du chemin 1"
    npa 1630
    city "Bulle"
    phone "+41790000000"
    country "CH"
    birthday { Date.new(1996, 2, 15) }
    gender "male"
    password "carottes"
    password_confirmation "carottes"
    confirmed true

    factory :volunteer do
      after(:create) do |user|
        user.create_volunteer!(year: 2018, tshirt_size: :m)
      end
    end

  end

  factory :order do
    transient do
      product_name :rj
    end

    user
    product { create(product_name) }
    pending false
  end

  factory :discount do
    category :money
    product "Records::Rj"
    reduction 2000
  end

end
