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

  factory :order_bundle do
    name { "Bénévole à la RJ19"}
    description { "Deviens bénévole durant le weekend de la RJ !"}
    key { "volunteers-rj-19" }
    open { true }

    order_type { :event }

    factory :order_bundle_with_items do
      after(:create) do |bundle|
        create(:item, order_bundle: bundle)
      end
    end
  end

  factory :option_order do
    sector { "fun_park" }
    comment { "I am ready !" }
    order_bundle
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

    factory :item_with_bundle do
      association :order_bundle, order_type: :event
    end

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
    association :order, factory: :event_order
    item {
      bundle = OrderBundle.find_by(key: "rj-2020") || create(:order_bundle_with_items, order_type: :event, key: "rj-2020")
      bundle.items.first
    }
  end

  factory :order_item do
    quantity { 1 }
    item
    order
  end

  factory :order do

    user
    pending { false }
    limited { false }
    
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

      registrants { build_list(:registrant, number, order: nil) }
    end

  end

  factory :form do
    name { "Bénévoles" }
    key { "volunteer" }

    factory :form_with_fields do

      after(:create) do |form|
        create(:field, name: "comment", required: true, form: form)
      end

    end
  end

  factory :field, class: "Form::Field" do
    name { "name" }
    required { true }
    field_type { "text" }
    form
  end

  factory :payment do
    payment_type { :main }
    add_attribute(:method) { :postfinance }
    amount { 0 }
    state { :confirmed }
  end

end
