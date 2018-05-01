class OrderPreview < ActionMailer::Preview
  def confirmation
    order = Order.last
    OrderMailer.confirmation(order)
  end

  def pass
    order = Order.last
    OrderMailer.pass(order)
  end

  def reminder
    OrderMailer.reminder
  end
end
