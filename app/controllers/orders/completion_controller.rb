require "#{Rails.root}/lib/order_completion.rb"

class Orders::CompletionController < Orders::BaseController
  before_action :closed, :not_pending, :check_if_not_signed_in, only: :update
  skip_before_action :verify_authenticity_token, only: :update

  def postfinance
    if params[:SHASIGN] == shaout.upcase
      @payment = Payment.find_by_payment_id!(params[:orderID])
      @order = @payment.order
      @payment.amount = params[:amount].to_i * 100
      @payment.status = params[:STATUS]
      @payment.payid = params[:PAYID]
      @payment.save
      order_completion.complete(:postfinance) if @payment.status == 5
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def update
    begin
      order_completion.complete
      redirect_to confirmed_orders_path
    rescue ArgumentError
      redirect_to confirmation_orders_event_path(@order.order_id), error: "Une erreur s'est produite"
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

  def order_completion
    @order_completion ||= OrderCompletion.new(@order)
  end

end
