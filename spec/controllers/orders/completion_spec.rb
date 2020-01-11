require 'rails_helper'

module Orders
  RSpec.describe CompletionController, :type => :controller do

    describe "#postfinance" do

      before(:each) do
        @order = create(:order)
      end

      it "updates order information from Postfinance request" do
        post :postfinance, params: {
          orderID: @order.main_payment.payment_id, amount: @order.main_payment.amount, STATUS: 9, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout.upcase
        }
        @order.main_payment.reload
        expect(@order.main_payment.status).to be(9)
        expect(@order.main_payment.payid).to be(3010824561)
      end

      it "updated order information form Postfinance request without NCERROR" do
        post :postfinance, params: {
          orderID: @order.main_payment.payment_id, amount: @order.main_payment.amount, STATUS: 1, PAYID: 3010824561, NCERROR: "", SHASIGN: shaout(status: 1, ncerror: false).upcase
        }
        @order.main_payment.reload
        expect(@order.main_payment.status).to be(1)
        expect(@order.main_payment.payid).to be(3010824561)
      end

      it "rejects a malicious request" do
        post :postfinance, params: {
          orderID: @order.main_payment.payment_id, amount: @order.main_payment.amount, STATUS: 9, PAYID: 3010824561, NCERROR: 0, SHASIGN: "random string"
        }
        @order.main_payment.reload
        expect(@order.main_payment.status).not_to be(9)
        expect(response.status).to be(422)
      end

      it "sends an email if the order is paid" do
        expect {
          post :postfinance, params: {
            orderID: @order.main_payment.payment_id, amount: @order.main_payment.amount, STATUS: 9, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout.upcase
          }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

    end
  end
end

def shaout(status: 9, ncerror: true)
  ncerror_str = "NCERROR=0#{Payment::KEY}" if ncerror.present?
  chain = "AMOUNT=#{@order.main_payment.amount}#{Payment::KEY}#{ncerror_str}"\
          "ORDERID=#{@order.main_payment.payment_id}#{Payment::KEY}PAYID=3010824561#{Payment::KEY}"\
          "STATUS=#{status}#{Payment::KEY}"
  return Digest::SHA1.hexdigest(chain)
end