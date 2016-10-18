require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do
  before(:each) do
    @order = create(:order)
  end

  it "updates order information from Postfinance request" do
    post :update, params: {
      orderID: @order.order_id, amount: @order.amount, STATUS: 5, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout
    }
    @order.reload
    expect(@order.status).to be(5)
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

  it "saves the volunteer options" do
    session[:volunteer_params] = { "door"=>"1", "install"=>"0", "other"=>"Available", "comment"=>"Thank you" }
    post :update, params: {
      orderID: @order.order_id, amount: @order.amount, STATUS: 5, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout
    }
    volunteers = Volunteer.all
    expect(volunteers.size).to eq(2)
    expect(volunteers.first.other).to eq("Available")
    expect(volunteers.first.comment).to eq("Thank you")
    expect(volunteers.second.sector).to eq("door")
  end

end

def shaout
  chain = "AMOUNT=#{@order.amount}#{Order::KEY}NCERROR=0#{Order::KEY}"\
          "ORDERID=#{@order.order_id}#{Order::KEY}PAYID=3010824561#{Order::KEY}"\
          "STATUS=5#{Order::KEY}"
  return Digest::SHA1.hexdigest(chain)
end
