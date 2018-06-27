class Connect::OrdersController < Connect::BaseController
  before_action :check_if_paid, only: :show

  def index
    @orders = current_user.completed_orders
  end

  def pending
    @orders = current_user.pending_orders
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = OrderPdf.new(@order.pdf_adapter)
        send_data pdf.render, filename: "Ticket_#{@order.order_id}.pdf", type: "application/pdf", disposition: 'inline'
      end
    end
  end

  private

  def check_if_paid
    @order = Order.find_by_order_id!(params[:id])
    if request.format.pdf? && !@order.paid?
      redirect_to connect_order_path(@order.order_id)
    end
  end
end
