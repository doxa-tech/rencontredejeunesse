class Orders::CompletionController < Orders::BaseController
  before_action :closed, :not_pending, :check_if_not_signed_in, only: :update

  def update
    begin
      order_completion = OrderCompletion.new(order)
      order_completion.complete
      redirect_to success_orders_path
    rescue ArgumentError
      redirect_to confirmation_orders_event_path(order.order_id), error: "Une erreur s'est produite"
    end
  end

end
