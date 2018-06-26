require 'rails_helper'

module Orders
  RSpec.describe "Event", :type => :model do

    describe "#calculate_amount" do

      it "assigns the right amount on create" do
        order = create(:order)
        expect(order.amount).to eq (Records::Rj.ENTRY_PRICE + Records::Rj::FEE) * 100
      end
  
      it "assigns the right amount on update" do
        order = create(:order)
        order.product.participants.first.lodging = true
        order.save
        expect(order.amount).to eq (Records::Rj.ENTRY_PRICE + Records::Rj::LODGING_PRICE + Records::Rj::FEE) * 100
      end
  
      it "assigns the right number of entries when deleting a registrant" do
        participants = build_list(:rj_participant, 2)
        product = create(:rj, participants: participants)
        order = create(:order, product: product)
        order.product.participants.first.mark_for_destruction
        order.save
        expect(order.amount).to eq (Records::Rj.ENTRY_PRICE + Records::Rj::FEE) * 100
      end       

    end
  end
end