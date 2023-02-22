require 'rails_helper'

RSpec.describe "Payment", :type => :model do

  it "updates order status" do
    order = create(:event_order)
    create(:payment, order: order, amount: order.amount)
    order.main_payment.update_attributes!(state: :fulfill)
    order.reload
    expect(order.status).to eq "paid"
  end

  describe "#method" do

    it "assigns invoice as payment method when the amount is above the limit" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      item = create(:item_with_bundle, price: 10000)
      order.registrants = create_list(:registrant, 10, order: order, item: item)
      order.save!
      expect(order.main_payment.method).to eq "invoice"
    end

    it "assigns postfinance as payment method when the amount is under the limit" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      expect(order.main_payment.method).to eq "postfinance"
    end

  end

  describe "#order_status" do

    it "return paid if the valid payments equal the order amount" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      order.main_payment.update_attributes!(state: :decline)
      order.payments.create!(amount: 4500, state: :fulfill, payment_type: "addition")
      order.payments.create!(amount: 2000, state: :fulfill, payment_type: "addition")
      expect(order.main_payment.order_status).to eq "paid"
    end

    it "return unpaid if the valid payments do not equal the order amount" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount - 1000)
      order.main_payment.update_attributes!(state: :fulfill)
      expect(order.main_payment.order_status).to eq "unpaid"
    end

    it "returns delivered if already delivered" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      order.update_attributes!(status: :delivered)
      order.reload
      order.main_payment.update_attributes!(state: :fulfill)
      expect(order.main_payment.order_status).to eq "delivered"
    end

    it "returns pending if there is a pending payment" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      order.main_payment.update_attributes!(state: :decline)
      order.payments.create!(amount: 6500, state: :processing, payment_type: "addition")
      expect(order.main_payment.order_status).to eq "pending"
    end

    it "returns progress if there is a payment in progress" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      order.main_payment.update_attributes!(state: :confirmed)
      expect(order.main_payment.order_status).to eq "progress"
    end

    it "returns paid even if there is a refund" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount + 2000)
      order.main_payment.update_attributes!(state: :fulfill, refund_amount: 2000, refund_state: :successful)
      expect(order.main_payment.order_status).to eq "paid"
    end

    it "returns refunded if there is a completed refund" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      order.main_payment.update_attributes!(state: :fulfill, refund_amount: 2000, refund_state: :successful)
      expect(order.main_payment.order_status).to eq "refunded"
    end

  end

  describe "#set_time_of_payment" do

    it "set the time if the payment is completed" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      order.main_payment.update_attributes!(state: :fulfill)
      expect(order.main_payment.time).not_to be nil
    end

    it "does not set the time if the payment is not completed" do
      order = create(:event_order)
      create(:payment, order: order, amount: order.amount)
      order.main_payment.update_attributes!(status: :processing)
      expect(order.main_payment.time).to be nil
    end

  end

end
