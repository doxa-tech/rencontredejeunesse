require_relative "./orders/callbacks.rb"

class OrdersController < ApplicationController
  before_action :update

  def confirmed
  end

  def canceled
  end

  def uncertain
  end

  def declined
  end

  private

  # request from Postfinance
  def update
    if params[:SHASIGN] == shaout.upcase
      @order = Order.find_by_order_id(params[:orderID])
      @order.status = params[:STATUS]
      @order.payid = params[:PAYID]
      @order.save
      if @order.status == 5
        OrderMailer.confirmation(@order).deliver_now
        Orders::Callbacks::Confirmation.send(@order.product_name, session[:volunteer_params], @order.user)
      end
    end
  end

  def shaout
    chain = "AMOUNT=#{params[:amount]}#{Order::KEY}NCERROR=#{params[:NCERROR]}#{Order::KEY}"\
            "ORDERID=#{params[:orderID]}#{Order::KEY}PAYID=#{params[:PAYID]}#{Order::KEY}"\
            "STATUS=#{params[:STATUS]}#{Order::KEY}"
    return Digest::SHA1.hexdigest(chain)
  end
end
