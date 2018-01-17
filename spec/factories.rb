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
  end

  factory :rj, class: Records::Rj do
    participants {[ build(:rj_participant) ]}
  end

  factory :login, class: Records::Login do
    participants {[ build(:login_participant) ]}
  end

  factory :rj_participant, class: Participants::Rj do
    gender "male"
    firstname "Patrick"
    lastname "Johnson"
    birthday Date.new(1996, 02, 15)
  end

  factory :login_participant, class: Participants::Login do
    gender "male"
    firstname "Patrick"
    lastname "Johnson"
    email "patrick@johnson.com"
    age 43
  end

  factory :order do
    transient do
      product_name :rj
    end

    user
    product { create(product_name) }
  end

end
