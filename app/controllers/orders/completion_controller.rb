require "#{Rails.root}/lib/order_completion.rb"

class Orders::CompletionController < Orders::BaseController
  before_action :closed, :not_pending, :check_if_not_signed_in, only: :update
  skip_before_action :verify_authenticity_token, only: :update

  def postfinance
    if params[:SHASIGN] == shaout.upcase
      @order = Order.find_by_order_id!(params[:orderID])
      @order.amount = params[:amount].to_i * 100
      @order.status = params[:STATUS]
      @order.payid = params[:PAYID]
      @order.save
      order_completion.complete(:postfinance) if @order.status == 5
      head :ok
      else
      head :unprocessable_entity
    end
  end

  def update
    begin
      order_completion.complete
      redirect_to orders_confirmed_path
    rescue ArgumentError
      redirect_to({ controller: "orders/#{@order.product_name}", action: "confirmation", id: @order.order_id }, error: "Une erreur s'est produite")
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

  def order_completion
    @order_completion ||= OrderCompletion.new(@order)
  end

end
