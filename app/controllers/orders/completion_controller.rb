class Orders::CompletionController < Orders::BaseController
  before_action :closed, :not_pending, :check_if_not_signed_in, only: :update
  skip_before_action :verify_authenticity_token, only: :postfinance

  def postfinance
    if params[:SHASIGN] == shaout.upcase
      @payment = Payment.find_by_payment_id!(params[:orderID])
      if params[:STATUS][0] == "8" # refund status
        @payment.refund_amount = params[:amount].to_i * 100
        @payment.refund_status = params[:STATUS]
      else
        @payment.amount = params[:amount].to_i * 100
        @payment.status = params[:STATUS]
      end
      @payment.payid = params[:PAYID]
      @payment.save
      order_completion = OrderCompletion.new(@payment.order)
      order_completion.complete(:postfinance) if @payment.order.paid?
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def update
    begin
      order_completion = OrderCompletion.new(order)
      order_completion.complete
      redirect_to confirmed_orders_path
    rescue ArgumentError
      redirect_to confirmation_orders_event_path(order.order_id), error: "Une erreur s'est produite"
    end
  end

  private

  def shaout
    ncerror = "NCERROR=#{params[:NCERROR]}#{Payment::KEY}" if params[:NCERROR].present?
    chain = "AMOUNT=#{params[:amount]}#{Payment::KEY}#{ncerror}"\
            "ORDERID=#{params[:orderID]}#{Payment::KEY}PAYID=#{params[:PAYID]}#{Payment::KEY}"\
            "STATUS=#{params[:STATUS]}#{Payment::KEY}"
    return Digest::SHA1.hexdigest(chain)
  end

end
