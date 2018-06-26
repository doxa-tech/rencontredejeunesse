require 'rails_helper'

module Orders
  RSpec.describe "Event", :type => :model do

    describe "#calculate_amount" do

      it "assigns the right amount on create" do
        order = create(:event_order, registrants: [])
        item = create(:item, price: 10000)
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
  end
end