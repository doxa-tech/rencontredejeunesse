require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do
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

end

def shaout(status: 5, ncerror: true)
  ncerror_str = "NCERROR=0#{Order::KEY}" if ncerror.present?
  chain = "AMOUNT=#{@order.amount}#{Order::KEY}#{ncerror_str}"\
          "ORDERID=#{@order.order_id}#{Order::KEY}PAYID=3010824561#{Order::KEY}"\
          "STATUS=#{status}#{Order::KEY}"
  return Digest::SHA1.hexdigest(chain)
end
