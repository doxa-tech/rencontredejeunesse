class Connect::OrdersController < Connect::BaseController

  def index
    @orders = current_user.completed_orders
  end

  def pending
    @orders = current_user.pending_orders
  end

  def show
    @order = Order.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        
        pdf = OrderPdf.new(@order)
        send_data pdf.render, filename: "Ticket#{@order.order_id}.pdf", 
          type: "application/pdf", disposition: 'inline'      
      end
    end
  end
end
