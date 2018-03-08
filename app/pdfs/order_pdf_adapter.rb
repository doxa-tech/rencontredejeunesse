class OrderPDFAdapter


  def initialize(order)
    @order = order
    @Product = Struct.new(:description, :product_number, :shipping_date, :quantity, :price, :tva, :amount)
  end

  def product
    @Product
  end

  # --- PDF Invoice interface implementation, see spec for definition --- #
  def recipient_adress
    "#{@order.user.full_name}
    #{@order.user.address}
    #{@order.user.country}-#{@order.user.npa} #{@order.user.city}
    #{@order.user.country_name}"
  end

  def title
    "Ticket de caisse #{@order.order_id}"
  end

  def order_date
    @order.created_at.strftime("%d.%m.%Y")
  end

  def client_id
    @order.human_id
  end

  def reference_person
    @order.user.full_name
  end

  def shipping_type
    "PDF"
  end

  def payment_type
    @order.payment_method
  end

  def currency
    "CHF"
  end

  def shipping_adress
    @order.user.email
  end

  def order_id
    @order.order_id
  end

  def products
    products_list = []
    products_list << @Product.new("Forfait RJ", "-", order_date, @order.product.entries.to_s, 
      '%.2f' % Records::Rj.ENTRY_PRICE(@order.created_at), 
      "incl. 8.0%", '%.2f' % Records::Rj.ENTRY_PRICE(@order.created_at))
    products_list << @Product.new("Places pour dormir GARS", "-", order_date, @order.product.man_lodging.to_s,
      '%.2f' % Records::Rj::LODGING_PRICE, "incl. 8.0%", 
      '%.2f' % (Records::Rj::LODGING_PRICE * @order.product.man_lodging))
    products_list << @Product.new("Places pour dormir FILLE", "-", order_date, @order.product.woman_lodging.to_s,
      '%.2f' % Records::Rj::LODGING_PRICE, "incl. 8.0%", 
      '%.2f' % (Records::Rj::LODGING_PRICE * @order.product.woman_lodging))
    products_list
  end
  

end