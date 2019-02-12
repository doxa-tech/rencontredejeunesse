class Connect::OrdersController < Connect::BaseController
  before_action :check_if_paid, only: [:ticket]

  def index
    @orders = current_user.completed_orders
  end

  def pending
    @orders = current_user.pending_orders
  end

  def show
    @order = order
  end

  def invoice
    respond_to do |format|
      format.pdf do
        pdf = InvoicePdf.new(order.invoice_pdf_adapter)
        send_data pdf.render, filename: "Facture_#{order.order_id}.pdf", type: "application/pdf", disposition: 'inline'
      end
    end
  end

  def ticket
    respond_to do |format|
      format.pdf do
        pdf = TicketPdf.new(order.ticket_pdf_adapter)
        send_data pdf.render, filename: "Tickets_#{order.order_id}.pdf", type: "application/pdf", disposition: 'inline'
      end
    end
  end

  private

  def order
    @order ||= Orders::Event.where(order_id: params[:id], user: current_user).first!
  end

  def check_if_paid
    unless order.paid?
      redirect_to connect_order_path(order.order_id)
    end
  end
end
