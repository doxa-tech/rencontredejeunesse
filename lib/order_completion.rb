class OrderCompletion
  include OrdersHelper

  def initialize(order)
    @order = order
  end

  def complete(situation = nil)
    @situation = situation || get_situation
    raise ArgumentError, "Argument is not allowed" unless @situation.in? situations
    common_steps
    send(@situation)
  end

  private

  def common_steps
    @order.discount.update_attribute(:used, true) if @order.discount
    OrderMailer.confirmation(@order).deliver_now
  end

  def postfinance
    send_pass
  end

  def free
    @order.update_column(:status, :paid)  
    send_pass
  end

  def invoice
    @order.payments.create!(
      payment_type: :main, amount: @order.amount, state: :processing
    ) 
    OrderMailer.invoice_registration(@order).deliver_now
  end

  def get_situation
    if is_invoice?(@order.amount)
      return :invoice
    elsif @order.amount == 0
      return :free
    end
    return nil
  end

  def send_pass
    OrderMailer.pass(@order).deliver_now if @order.order_type == :event
  end

  def situations
    [:postfinance, :invoice, :free]
  end

end
