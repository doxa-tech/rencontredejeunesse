class Admin::PaymentsController < Admin::BaseController
  load_and_authorize

  def create
    @event = Order.find(params[:order_id])
    @payment = @event.payments.new(payment_params)
    if @payment.save
      redirect_to edit_admin_orders_event_path(@event)
    else
      render 'edit'
    end
  end

  def edit
  end

  def update
    if @payment.update_attributes(payment_params)
      redirect_to edit_admin_orders_event_path(@payment.order_id)
    else
      render 'edit'
    end
  end

  def destroy
    @payment.destroy
    redirect_to edit_admin_orders_event_path(@payment.order_id)
  end

  private

  def payment_params
    params.require(:payment).permit(:payment_type, :amount, :state)
  end
end
