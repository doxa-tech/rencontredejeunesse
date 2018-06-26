require 'rails_helper'

RSpec.describe OrderCompletion do

  it "rejects an order with the payment method postfinance" do
    order = create(:order)
    post :complete, params: { id: order.order_id }
    order.reload
    expect(response).to redirect_to "/orders/#{order.product_name}/#{order.order_id}/confirmation"
  end

  describe "#common_steps" do
  
    it "sets a discount as used" do
      @order.discount = create(:discount)
      @order.save!
      post :update, params: {
        orderID: @order.order_id, amount: @order.amount, STATUS: 5, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout.upcase
      }
      @order.reload
      expect(@order.discount.used).to eq true
    end

    it "sends a confirmation email" do
      expect {
        post :update, params: {
          orderID: @order.order_id, amount: @order.amount, STATUS: 5, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout.upcase
        }
      }.to change(ActionMailer::Base.deliveries, :size).by(2)
    end

  end

  describe "#invoice" do

    it "updates an order with the payment method invoice" do
      participants = build_list(:rj_participant, 15, lodging: true)
      product = create(:rj, participants: participants)
      order = create(:order, product: product)
      post :complete, params: { id: order.order_id }
      order.reload
      expect(order.status).to be 41
    end

  end

  describe "#postfinance" do

  end

  describe "#free" do

    it "updates an order with an amount of zero" do
      order = create(:order)
      order.lump_sum = 0
      order.save
      post :complete, params: { id: order.order_id }
      order.reload
      expect(order.status).to be 9
    end

  end
end