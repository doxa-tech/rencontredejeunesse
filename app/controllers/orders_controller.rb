class OrdersController < Orders::BaseController
  before_action :check_if_not_signed_in, only: [:destroy, :pay]
  before_action :closed, only: :pay

  def pay
    payment = order.payments.create!(
      payment_type: :main, method: :postfinance, amount: order.amount, state: :confirmed
    )
    transaction = OrderTransaction.new(order, payment)
    payment_url = transaction.execute
    redirect_to payment_url
  end

  def destroy
    current_user.orders.find_by_order_id!(params[:id]).destroy
    redirect_to pending_connect_orders_path
  end

  def success; end

  def failed; end

end
