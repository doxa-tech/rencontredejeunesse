require 'rails_helper'
require 'interfaces/pdf_invoice'
require 'interfaces/pdf_ticket'

module Orders
  RSpec.describe "Event", :type => :model do

    it_should_behave_like "an invoice PDF responder" do
      let(:responder) do
        order = create(:event_order, number: 2)
        order.invoice_pdf_adapter
      end
    end

    it_should_behave_like "a ticket PDF responder" do
      let(:responder) do
        order = create(:event_order, number: 2)
        order.ticket_pdf_adapter
      end
    end

    describe "#calculate_amount" do

      it "assigns the right amount on create" do
        order = create(:event_order, registrants: [])
        item = create(:item_with_bundle, price: 10000)
        order.registrants = create_list(:registrant, 2, item: item, order: order)
        order.save!
        expect(order.amount).to eq 20000 + order.fee
      end
  
      it "assigns the right amount on update" do
        order = create(:event_order)
        order.registrants.first.item = create(:item, price: 4000)
        order.save!
        expect(order.amount).to eq 4000 + order.fee
      end
  
      it "assigns the right amount on destroy" do
        order = create(:event_order, number: 2)
        order.registrants.first.mark_for_destruction
        order.save!
        expect(order.amount).to eq order.registrants.last.item.price + order.fee
      end       

    end

    context  "validations" do
      let!(:order) { create(:event_order, registrants: []) }

      it "is possible to order an item with the type event" do
        order_type = create(:order_type, name: "event")
        bundle = create(:order_bundle, order_type: order_type)
        order.registrants = [create(:registrant, item: bundle.items.first, order: order)]
        order.save
        expect(order.errors[:base]).to be_empty
      end

      it "is possible to order an item with a subtype from event" do
        event_type = create(:order_type, name: "event")
        subtype = create(:order_type, name: "volunteer", supertype_id: event_type.id)
        bundle = create(:order_bundle, order_type: subtype)
        order.registrants = [create(:registrant, item: bundle.items.first, order: order)]
        order.save
        expect(order.errors[:base]).to be_empty
      end

      it "is not possible to order an item that has no bundle" do
        item = create(:item, order_bundle: nil)
        order.registrants = [create(:registrant, item: item, order: order)]
        order.save
        expect(order.errors[:base]).to include "Un article n'est pas dans un bundle."
      end

      it "is not possible to order an item that has a bundle with the wrong category" do
        order_type = create(:order_type, name: "sales")
        bundle = create(:order_bundle, order_type: order_type)
        order.registrants = [create(:registrant, item: bundle.items.first, order: order)]
        order.save
        expect(order.errors[:base]).to include "Un article n'est pas compatible."
      end

      it "is not possible to order items with different bundles" do
        sales_bundle = create(:order_bundle, order_type: create(:order_type, name: "sales"))
        event_bundle = create(:order_bundle, order_type: create(:order_type, name: "event"))
        order.registrants = [
          create(:registrant, item: sales_bundle.items.first, order: order),
          create(:registrant, item: event_bundle.items.first, order: order)
        ]
        order.save
        expect(order.errors[:base]).to include "Les articles ne font pas partie du même bundle."
      end

    end
  end
end