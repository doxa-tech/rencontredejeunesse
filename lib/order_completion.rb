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
    OrderMailer.pass(@order).deliver_now
  end

  def free
    @order.update_attribute(:status, statuses[@situation])
    OrderMailer.pass(@order).deliver_now
  end

  def invoice
    @order.update_attribute(:status, statuses[@situation])
    Admin::OrderMailer.invoice_registration(@order).deliver_now
  end

  def get_situation
    if @order.invoice?
      :invoice
    elsif @order.amount == 0
      :free
    end
  end

  def statuses
    { invoice: 41, free: 9 }
  end

  def situations
    [:postfinance, :invoice, :free]
  end

end
