class Admin::PaymentsController < Admin::BaseController
  load_and_authorize

  def create
    @order = Order.find(params[:order_id])
    @payment = @order.payments.new(payment_attributes)
    if @payment.save
      redirect_to edit_admin_orders_event_path(@order)
    else
      render 'admin/orders/events/edit'
    end
  end

  def edit
  end

  def update
    if @payment.update(payment_attributes)
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

  def payment_attributes
    params.require(:payment).permit(:payment_type, :amount, :status)
  end
end
