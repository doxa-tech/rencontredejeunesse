class Admin::Orders::RjPreview < ActionMailer::Preview

  def group_registration
    order = Order.where(product_type: "Records::Rj").last
    Admin::Orders::RjMailer.group_registration(order, nil)
  end

end
