class Orders::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :state_update

  def state_update
    entity_id = params[:entityId]
    space_id = Rails.application.secrets.postfinance_space_id

    if entity_id.nil?
      head :bad_request
      return
    end

    # read request
    begin
      transaction_service = PostFinanceCheckout::TransactionService.new
      transaction = transaction_service.read(space_id, entity_id)
    rescue PostFinanceCheckout::ApiError
      head :bad_request
      return
    end

    if transaction.nil?
      head :bad_request
      return
    end

    # update payment
    payment = Payment.find_by!(payment_id: transaction.merchant_reference)
    order = payment.order
    old_status = order.status

    payment.update(state: transaction.state.downcase)
  
    if old_status != "paid" && order.reload.status == "paid"
      order_completion = OrderCompletion.new(order)
      order_completion.complete(:postfinance)
    end

    head :ok
  end

  def refund
    # TODO
  end

end
