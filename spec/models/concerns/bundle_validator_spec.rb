require 'rails_helper'

RSpec.describe "BundleValidator" do
  let!(:order) { build(:event_order, registrants: []) }

  describe "#presence_of_bundle" do
        
    it "is not possible to order an item that has no bundle" do
      item = create(:item, order_bundle: nil)
      order.registrants = [create(:registrant, item: item, order: order)]
      order.save
      expect(order.errors[:base]).to include "Un article n'est pas dans un bundle."
    end
  
  end

  describe "#uniqueness_of_bundle" do

    it "is not possible to order items with different bundles" do
      sales_bundle = create(:order_bundle_with_items)
      event_bundle = create(:order_bundle_with_items)
      order.registrants = [
        create(:registrant, item: sales_bundle.items.first, order: order),
        create(:registrant, item: event_bundle.items.first, order: order)
      ]
      order.save
      expect(order.errors[:base]).to include "Les articles ne font pas partie du même bundle."
    end

  end

  describe "#name_of_order_type" do

    it "is possible to order an item with the type event" do
      bundle = create(:order_bundle_with_items, order_type: :event)
      order.registrants = [create(:registrant, item: bundle.items.first, order: order)]
      order.save
      expect(order.errors[:base]).to be_empty
    end

    it "is not possible to order an item that has a bundle with the wrong category" do
      bundle = create(:order_bundle_with_items, order_type: :regular)
      order.registrants = [create(:registrant, item: bundle.items.first, order: order)]
      order.save
      expect(order.errors[:base]).to include "Un article n'est pas compatible."
    end

  end

  describe "#availability_of_bundle" do

    it "should possible to order an item in a open bundle" do
      bundle = create(:order_bundle_with_items, open: true)
      order.registrants = [create(:registrant, item: bundle.items.first, order: order)]
      expect(order).to be_valid
    end

    it "should not be possible to order an item in a closed bundle" do
      bundle = create(:order_bundle_with_items, open: false)
      order.registrants = [create(:registrant, item: bundle.items.first, order: order)]
      order.save
      expect(order.errors[:base]).to include "Les articles ne sont pas disponibles."
    end

    it "should be possible to bypass a closed bundle if the order allows closed bundle" do
      bundle = create(:order_bundle_with_items, open: false)
      order.registrants = [create(:registrant, item: bundle.items.first, order: order)]
      order.limited = true
      expect(order).to be_valid
    end

  end

  describe "limit_in_bundle" do

    it "should be valid if the order has not more registrants than the limit" do
      bundle = create(:order_bundle_with_items, limit: 2)
      order.registrants = build_list(:registrant, 2, order: nil, item: bundle.items.first)
      expect(order).to be_valid
    end

    it "should not be valid if the order has more registrants than the limit" do
      bundle = create(:order_bundle_with_items, limit: 1)
      order.registrants = build_list(:registrant, 2, order: nil, item: bundle.items.first)
      expect(order).not_to be_valid
    end

  end

end