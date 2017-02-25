class OrderPreview < ActionMailer::Preview
  def confirmation
    order = Order.last
    OrderMailer.confirmation(order)
  end

  def invoice_for_rj
    order = Order.where(product_type: "Records::Rj").last
    OrderMailer.invoice_for_rj(order)
  end
end
