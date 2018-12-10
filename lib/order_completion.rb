class OrderCompletion

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
    @order.main_payment.update_attribute(:status, statuses[@situation])
    send_pass
  end

  def invoice
    @order.main_payment.update_attribute(:status, statuses[@situation])
    OrderMailer.invoice_registration(@order).deliver_now
  end

  def get_situation
    if @order.main_payment.invoice?
      :invoice
    elsif @order.amount == 0
      :free
    end
  end

  def send_pass
    OrderMailer.pass(@order).deliver_now if @order.order_type == :event
  end

  def statuses
    { invoice: 41, free: 9 }
  end

  def situations
    [:postfinance, :invoice, :free]
  end

end
