class Orders::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:state_update, :refund_update]

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
    rescue PostFinanceCheckout::ApiError => e
      Rails.logger.fatal "Postfinance API error:"
      Rails.logger.fatal e.response_body
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

  def refund_update
    entity_id = params[:entityId]
    space_id = Rails.application.secrets.postfinance_space_id

    if entity_id.nil?
      head :bad_request
      return
    end

    # read request
    begin
      refund_service = PostFinanceCheckout::RefundService.new
      refund = refund_service.read(space_id, entity_id)
    rescue PostFinanceCheckout::ApiError => e
      Rails.logger.fatal "Postfinance API error:"
      Rails.logger.fatal e.response_body
      head :bad_request
      return
    end

    if refund.nil?
      head :bad_request
      return
    end

    # update payment
    # the amount is multiplied by 100, because PF does not give the amount in cents
    payment = Payment.find_by!(payment_id: refund.transaction.merchant_reference)
    payment.update(refund_amount: refund.amount * 100, refund_state: refund.state.downcase)
    
    head :ok
  end

end
