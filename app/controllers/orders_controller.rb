require_relative "./orders/callbacks.rb"

class OrdersController < ApplicationController

  def confirmed
  end

  def canceled
  end

  def uncertain
  end

  def declined
  end

  # request from Postfinance
  def update
    if params[:SHASIGN] == shaout
      @order = Order.find_by_order_id(params[:orderID])
      @order.status = params[:STATUS]
      @order.payid = params[:PAYID]
      @order.save
      if @order.status == 5
        OrderMailer.confirmation(@order).deliver_now
        Callbacks::Confirmation.send(@order.product_name, session[:volunteer_params], @order.user)
      end
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def shaout
    chain = "AMOUNT=#{params[:amount]}#{Order::KEY}NCERROR=#{params[:NCERROR]}#{Order::KEY}"\
            "ORDERID=#{params[:orderID]}#{Order::KEY}PAYID=#{params[:PAYID]}#{Order::KEY}"\
            "STATUS=#{params[:STATUS]}#{Order::KEY}"
    return Digest::SHA1.hexdigest(chain)
  end
end
