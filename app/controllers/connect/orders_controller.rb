class Connect::OrdersController < Connect::BaseController
  before_action :check_if_paid, only: [:show, :invoice, :ticket]

  def index
    @orders = current_user.completed_orders
  end

  def pending
    @orders = current_user.pending_orders
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def invoice
    respond_to do |format|
      format.pdf do
        pdf = InvoicePdf.new(@order.invoice_pdf_adapter)
        send_data pdf.render, filename: "Facture_#{@order.order_id}.pdf", type: "application/pdf", disposition: 'inline'
      end
    end
  end

  def ticket
    respond_to do |format|
      format.pdf do
        pdf = TicketPdf.new(@order.ticket_pdf_adapter)
        send_data pdf.render, filename: "Facture_#{@order.order_id}.pdf", type: "application/pdf", disposition: 'inline'
      end
    end
  end

  private

  def check_if_paid
    @order = Orders::Event.find_by_order_id!(params[:id])
    if request.format.pdf? && !@order.paid?
      redirect_to connect_order_path(@order.order_id)
    end
  end
end
