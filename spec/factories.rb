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

  factory :item do
    name "Rencontre de jeunesse 2018 - WE"
    price 6000
    active true
    number 5045
    key "rj"
  end

  factory :discount do
    category :money
    reduction 2000
  end

  factory :registrant do
    gender "male"
    firstname "Patrick"
    lastname "Johnson"
    birthday Date.new(1996, 02, 15)
    item
    association :order, factory: :event_order
  end

  factory :event_order, class: "Orders::Event" do

    order_type :event
    user
    pending false
    
    after(:create) do |order|
      create(:registrant, order: order)
      order.reload
    end

  end

end
