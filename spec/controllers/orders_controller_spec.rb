require 'rails_helper'

RSpec.describe OrdersController do

  describe "POST pay" do

    it "removes the previous main payment" do
      sign_in
      @item = create(:item_with_bundle)
      @order = create(:event_order, user: @user)
      payment = @order.payments.create(
        payment_type: :main, method: :postfinance, amount: @order.amount, state: :confirmed
      )
      post :pay, params: { id: @order.order_id, key: @item.order_bundle.key }
      payment.reload
      expect(payment.payment_type).to eq "discarded"
    end

  end
end

def sign_in
  @user = create(:user, confirmed: true)
  request.cookies[:remember_token] = @user.remember_token
end