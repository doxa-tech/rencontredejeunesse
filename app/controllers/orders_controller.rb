require_relative "./orders/callbacks.rb"

class OrdersController < Orders::BaseController
  skip_before_action :verify_authenticity_token, only: :update
  skip_before_action :closed, only: :update

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
    if params[:SHASIGN] == shaout.upcase
      @order = Order.find_by_order_id(params[:orderID])
      @order.amount = params[:amount]
      @order.status = params[:STATUS]
      @order.payid = params[:PAYID]
      @order.save
      if @order.status == 5
        OrderMailer.confirmation(@order).deliver_now
        Orders::Callbacks::Confirmation.send(@order.product_name, @order)
      end
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @order = Order.find_by_order_id(params[:id])
    @order.destroy if @order
    redirect_to pending_connect_orders_path
  end

  def complete
    if @order.payment_method == "invoice"
      OrderMailer.confirmation(@order).deliver_now
      Orders::Callbacks::Confirmation.send(@order.product_name, @order)
      Admin::OrderMailer.invoice_registration(@order).deliver_now
      @order.update_attribute(:status, 41)
      redirect_to orders_confirmed_path
    else
      redirect_to controller: "orders/#{@order.product_name}", action: "confirmation", id: @order.order_id, error: "Une erreur s'est produite"
    end
  end

  private

  def shaout
    ncerror = "NCERROR=#{params[:NCERROR]}#{Order::KEY}" if params[:NCERROR].present?
    chain = "AMOUNT=#{params[:amount]}#{Order::KEY}#{ncerror}"\
            "ORDERID=#{params[:orderID]}#{Order::KEY}PAYID=#{params[:PAYID]}#{Order::KEY}"\
            "STATUS=#{params[:STATUS]}#{Order::KEY}"
    return Digest::SHA1.hexdigest(chain)
  end
end
