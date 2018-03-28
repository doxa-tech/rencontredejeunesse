require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do

  describe "#update" do

    before(:each) do
      @order = create(:order)
    end

    it "updates order information from Postfinance request" do
      post :update, params: {
        orderID: @order.order_id, amount: @order.amount, STATUS: 5, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout.upcase
      }
      @order.reload
      expect(@order.status).to be(5)
      expect(@order.payid).to be(3010824561)
    end

    it "updated order information form Postfinance request without NCERROR" do
      post :update, params: {
        orderID: @order.order_id, amount: @order.amount, STATUS: 1, PAYID: 3010824561, NCERROR: "", SHASIGN: shaout(status: 1, ncerror: false).upcase
      }
      @order.reload
      expect(@order.status).to be(1)
      expect(@order.payid).to be(3010824561)
    end

    it "rejects a malicious request" do
      post :update, params: {
        orderID: @order.order_id, amount: @order.amount, STATUS: 5, PAYID: 3010824561, NCERROR: 0, SHASIGN: "random string"
      }
      @order.reload
      expect(@order.status).not_to be(5)
      expect(response.status).to be(422)
    end

    it "confirms a volunteer" do
      @order.lump_sum = (Records::Rj::VOLUNTEER_TOTAL) * 100
      @order.case = :volunteer
      @order.save!
      volunteer = @order.user.create_volunteer!(year: 2018, tshirt_size: :m)
      post :update, params: {
        orderID: @order.order_id, amount: @order.amount, STATUS: 5, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout.upcase
      }
      expect(volunteer.reload.confirmed).to eq true
    end

    it "sets a discount as used" do
      @order.discount = create(:discount)
      @order.save!
      post :update, params: {
        orderID: @order.order_id, amount: @order.amount, STATUS: 5, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout.upcase
      }
      @order.reload
      expect(@order.discount.used).to eq true
    end

  end

  describe "#complete" do

    it "updates an order with the payment method invoice" do
      participants = build_list(:rj_participant, 15, lodging: true)
      product = create(:rj, participants: participants)
      order = create(:order, product: product)
      post :complete, params: { id: order.order_id }
      order.reload
      expect(order.status).to be 41
    end

    it "updates an order with an amount of zero" do
      order = create(:order)
      order.lump_sum = 0
      order.save
      post :complete, params: { id: order.order_id }
      order.reload
      expect(order.status).to be 9
    end

    it "rejects an order with the payment method postfinance" do
      order = create(:order)
      post :complete, params: { id: order.order_id }
      order.reload
      expect(order.status).to eq nil
    end

  end

end

def shaout(status: 5, ncerror: true)
  ncerror_str = "NCERROR=0#{Order::KEY}" if ncerror.present?
  chain = "AMOUNT=#{@order.amount}#{Order::KEY}#{ncerror_str}"\
          "ORDERID=#{@order.order_id}#{Order::KEY}PAYID=3010824561#{Order::KEY}"\
          "STATUS=#{status}#{Order::KEY}"
  return Digest::SHA1.hexdigest(chain)
end
