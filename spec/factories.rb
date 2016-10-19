FactoryGirl.define do

  factory :user do
    firstname "John"
    lastname "Smith"
    email { "#{firstname.downcase}@#{lastname.downcase}.com" }
    address "Route du chemin 1"
    npa 1630
    city "Bulle"
    phone "1010010110"
    country "CH"
  end

  factory :rj, class: Records::Rj do
    entries 1
  end

  factory :login, class: Records::Rj do
    entries 1
  end

  factory :order do
    transient do
      product_name :rj
    end

    user
    product { create(product_name) }
  end

end
