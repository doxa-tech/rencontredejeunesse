class Orders::RjPreview < ActionMailer::Preview

  def group_registration
    order = Order.where(product_type: "Records::Rj").last
    Orders::RjMailer.group_registration(order)
  end

end
