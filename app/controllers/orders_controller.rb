class OrdersController < ApplicationController

  def confirmed
  end

  def canceled
  end

<<<<<<< HEAD
  def uncertain
=======
  def incertain
>>>>>>> 8fd78ddd29b40d29ce11ba8f2506a80817a7552e
  end

  def declined
  end

  # request from Postfinance
  def update
    if params[:shasign] == shaout
      @order = Order.find_by_order_id(params[:orderID])
      @order.status = params[:STATUS]
      @order.payid = params[:PAYID]
      @order.save
      if @order.status == 5
        OrderMailer.confirmation(@order.user.email, @order.product_type.underscore).deliver_now
        Callback::Confirmation.send(@order.product_name)
      end
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def shaout
    chain = "NCERROR=#{params[:NCERROR]}#{Order::KEY}PAYID=#{params[:PAYID]}#{Order::KEY}"\
            "STATUS=#{params[:STATUS]}#{Order::KEY}AMOUNT=#{params[:amount]}#{Order::KEY}"\
            "ORDERID=#{params[:orderID]}#{Order::KEY}"
    return Digest::SHA1.hexdigest(chain)
  end
end
