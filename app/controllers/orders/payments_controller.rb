class Orders::PaymentsController < Orders::BaseController
  before_action :check_if_signed_in

  def show
    @payment = Payment.pending_on_postfinance.find_by!(payment_id: params[:id])
    @order = @payment.order
  end

  def pay
    # redirect to Postfinance to pay
    payment = Payment.pending_on_postfinance.find_by!(payment_id: params[:id])
    payment.update(state: :confirmed)
    transaction = OrderTransaction.new(payment.order, payment)
    payment_url = transaction.execute_payment
    redirect_to payment_url
  end
end
