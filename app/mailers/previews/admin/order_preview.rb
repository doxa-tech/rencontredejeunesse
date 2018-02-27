class Admin::OrderPreview < ActionMailer::Preview

  def invoice_registration
    order = Order.last
    Admin::OrderMailer.invoice_registration(order)
  end

end
