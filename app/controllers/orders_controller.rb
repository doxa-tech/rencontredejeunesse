class OrdersController < Orders::BaseController
  before_action :check_if_not_signed_in, only: [:destroy, :pay]
  before_action :closed, only: :pay

  def pay
    # creates the main payment and redirect to Postfinance
    order.main_payment.try(:update_column, :payment_type, :discarded)
    payment = order.payments.create!(
      payment_type: :main, method: :postfinance, amount: order.amount, state: :confirmed
    )
    transaction = OrderTransaction.new(order, payment)
    payment_url = transaction.execute_order
    if payment_url != nil
      redirect_to payment_url
    else
      redirect_to confirmation_orders_event_path(order.order_id, key: order.bundle.key), error: "Une erreur s'est produite avec le paiement, réessaye plus tard."
    end
  end

  def destroy
    current_user.orders.find_by_order_id!(params[:id]).destroy
    redirect_to pending_connect_orders_path
  end

  def success; end

  def failed; end

end
