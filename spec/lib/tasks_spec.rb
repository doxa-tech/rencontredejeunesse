require 'rails_helper'
require 'rake'
Rails.application.load_tasks

RSpec.describe "Tasks" do

  # NOT RELEVANT ANYMORE
  # describe "migrate.rake" do

  #   after(:each) { Rake::Task['migrate:order_types'].reenable }

  #   it "should update volunteer type" do
  #     type = OrderType.create!(name: :volunteer)
  #     bundle = create(:order_bundle, order_type_id: type.id)
  #     Rake::Task['migrate:order_types'].invoke
  #     bundle.reload
  #     expect(bundle.order_type).to eq "event"
  #     expect(bundle.bundle_type).to eq "volunteer"
  #   end

  #   it "should update stand type" do
  #     type = OrderType.create!(name: :stands)
  #     bundle = create(:order_bundle, order_type_id: type.id)
  #     Rake::Task['migrate:order_types'].invoke
  #     bundle.reload
  #     expect(bundle.order_type).to eq "event"
  #     expect(bundle.bundle_type).to eq "stand"
  #   end

  #   it "should update event type" do
  #     type = OrderType.create!(name: :event)
  #     bundle = create(:order_bundle, order_type_id: type.id)
  #     Rake::Task['migrate:order_types'].invoke
  #     bundle.reload
  #     expect(bundle.order_type).to eq "event"
  #     expect(bundle.bundle_type).to be_nil
  #   end

  #   it "should update stand type" do
  #     type = OrderType.create!(name: :regular)
  #     bundle = create(:order_bundle, order_type_id: type.id)
  #     Rake::Task['migrate:order_types'].invoke
  #     bundle.reload
  #     expect(bundle.order_type).to eq "regular"
  #     expect(bundle.bundle_type).to be_nil
  #   end

  #   it "should transfer the form to the bundle" do
  #     form = create(:form)
  #     type = OrderType.create!(name: :regular, form: form)
  #     bundle1 = create(:order_bundle, order_type_id: type.id, key: "key-1")
  #     bundle2 = create(:order_bundle, order_type_id: type.id, key: "key-2")
  #     Rake::Task['migrate:order_types'].invoke
  #     bundle1.reload
  #     bundle2.reload
  #     expect(bundle1.form).to eq form
  #     expect(bundle2.form).to eq form
  #   end

  # end


end