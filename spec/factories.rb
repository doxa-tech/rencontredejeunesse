FactoryBot.define do

  factory :user do
    firstname "John"
    lastname "Smith"
    email { "#{firstname.downcase}@#{lastname.downcase}.com" }
    address "Route du chemin 1"
    npa 1630
    city "Bulle"
    phone "1010010110"
    country "CH"
    birthday { Date.new(1996, 2, 15) }
    gender "male"
  end

  factory :rj, class: Records::Rj do
  end

  factory :login, class: Records::Login do
    entries 1
  end

  factory :order do
    transient do
      product_name :rj
    end

    user
    product { create(product_name) }
  end

  factory :volunteer do
    sector "install"
  end

end
