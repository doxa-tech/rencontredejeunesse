require 'rails_helper'

RSpec.describe "Payment", :type => :model do

  it "updates order status" do
    order = create(:event_order)
    order.main_payment.update_attributes(status: 9)
    expect(order.status).to eq "paid"
  end

  describe "#method" do

    it "assigns invoice as payment method when the amount is above the limit" do
      order = create(:event_order)
      item = create(:item, price: 10000)
      order.registrants = create_list(:registrant, 10, order: order, item: item)
      order.save!
      expect(order.main_payment.method).to eq "invoice"
    end

    it "assigns postfinance as payment method when the amount is under the limit" do
      order = create(:event_order)
      expect(order.main_payment.method).to eq "postfinance"
    end

  end

  describe "#order_status" do

    it "return paid if the valid payments equal the order amount" do
      order = create(:event_order)
      order.main_payment.update_attributes(status: 1)
      order.payments.create(amount: 4500, status: 9, payment_type: :addition)
      order.payments.create(amount: 2000, status: 9, payment_type: :addition)
      expect(order.main_payment.order_status).to eq "paid"
    end

    it "return unpaid if the valid payments do not equal the order amount" do
      order = create(:event_order)
      order.main_payment.update_attributes(status: 9)
      order.payments.create(amount: -6500, status: 9, payment_type: :refund)
      expect(order.main_payment.order_status).to eq "unpaid"
    end

    it "returns delivered if already delivered" do
      order = create(:event_order, status: :delivered)
      expect(order.main_payment.order_status).to eq "delivered"
    end

  end

end
