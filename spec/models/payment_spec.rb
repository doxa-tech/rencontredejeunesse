require 'rails_helper'

RSpec.describe "Payment", :type => :model do

  describe "payment method" do

    it "assigns invoice as payment method when the amount is above the limit" do
      participants = build_list(:rj_participant, 15, lodging: true)
      product = create(:rj, participants: participants)
      order = create(:order, product: product)
      expect(order.payment_method).to eq "invoice"
    end

    it "assigns postfinance as payment method when the amount is under the limit" do
      order = create(:order)
      expect(order.payment_method).to eq "postfinance"
    end

  end

end
