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
        order.registrants.first.item = create(:item_with_bundle, price: 4000)
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
  end
end