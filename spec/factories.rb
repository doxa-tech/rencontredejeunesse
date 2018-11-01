FactoryBot.define do

  factory :user do
    firstname { "John" }
    lastname { "Smith" }
    email { "#{firstname.downcase}@#{lastname.downcase}.com" }
    address { "Route du chemin 1" }
    npa { 1630 }
    city { "Bulle" }
    phone { "+41790000000" }
    country { "CH" }
    birthday { Date.new(1996, 2, 15) }
    gender { "male" }
    password { "carottes" }
    password_confirmation { "carottes" }
    confirmed { true }

  end

  factory :volunteering do
    name { "Bénévole à la RJ19"}
    description { "Deviens bénévole durant le weekend de la RJ !"}
    key { "rj2019" }
    item  { create(:item, name: "Bénévole RJ19") }
  end

  factory :volunteer do
    sector { "fun_park" }
    comment { "I am ready !" }
    volunteering
    user
    order { create(:event_order, user: self.user) }
  end

  factory :item do
    name { "Rencontre de jeunesse 2018 - WE" }
    description { "RJ 2018" }
    price { 6000 }
    active { true }
    number { Random.new.rand(1000..9999) }
    key { "rj" }
  end

  factory :discount do
    category { "money" }
    reduction { 2000 }
  end

  factory :registrant do
    gender { "male" }
    firstname { "Patrick" }
    lastname { "Johnson" }
    birthday { Date.new(1996, 02, 15) }
    item
    association :order, factory: :event_order
  end

  factory :order_item do
    quantity { 1 }
    item
    order
  end

  factory :order do

    order_type { "regular" }
    user
    pending { false }
    
    factory :order_with_items do
      transient do
        number { 1 }
        quantity { 1 }
      end

      after(:create) do |order, evaluator|
        order.order_items = create_list(:order_item, evaluator.number, quantity: evaluator.quantity, order: order)
        order.save!
      end
    end

    factory :event_order, class: "Orders::Event" do
      transient do
        number { 1 }
      end

      order_type { "event" }
      registrants { build_list(:registrant, number, order: nil) }
    end

  end

end
