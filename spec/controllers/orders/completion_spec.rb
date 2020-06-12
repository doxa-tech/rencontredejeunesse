require 'rails_helper'

module Orders
  RSpec.describe CompletionController, :type => :controller do

    describe "#postfinance" do

      before(:each) do
        @order = create(:order)
        # a different amount is submitted to check whether the request updates correctly
        @amount = (@order.main_payment.amount + 10)/100
      end

      it "updates order information from Postfinance request" do
        post :postfinance, params: {
          orderID: @order.main_payment.payment_id, amount: @amount, STATUS: 9, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout.upcase
        }
        @order.main_payment.reload
        expect(@order.main_payment.status).to be(9)
        expect(@order.main_payment.amount).to be(@amount*100)
        expect(@order.main_payment.payid).to be(3010824561)
      end

      it "updates order information form Postfinance request without NCERROR" do
        post :postfinance, params: {
          orderID: @order.main_payment.payment_id, amount: @amount, STATUS: 1, PAYID: 3010824561, NCERROR: "", SHASIGN: shaout(status: 1, ncerror: false).upcase
        }
        @order.main_payment.reload
        expect(@order.main_payment.status).to be(1)
        expect(@order.main_payment.amount).to be(@amount*100)
        expect(@order.main_payment.payid).to be(3010824561)
      end

      it "updates refund amount and status from Postfinance request in case of a refund" do 
        post :postfinance, params: {
          orderID: @order.main_payment.payment_id, amount: @amount, STATUS: 81, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout(status: 81).upcase
        }
        @order.main_payment.reload
        expect(@order.main_payment.refund_status).to be(81)
        expect(@order.main_payment.refund_amount).to be(@amount*100)
      end

      it "does not update the amount and status from Postfinance request in case of a refund" do
        current = @order.main_payment.amount
        post :postfinance, params: {
          orderID: @order.main_payment.payment_id, amount: @amount, STATUS: 81, PAYID: 3010824561, NCERROR: 0, SHASIGN: shaout(status: 81).upcase
        }
        expect(@order.main_payment.status).to be(nil)
        expect(@order.main_payment.amount).to be(current*100)
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