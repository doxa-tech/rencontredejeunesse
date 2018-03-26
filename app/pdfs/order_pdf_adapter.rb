class OrderPDFAdapter
  attr_reader :products, :payments

  class Product
    attr_reader :description, :product_number, :shipping_date, :quantity, :price, :tva, :display_amount, :amount

    def initialize args
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
      @display_amount = '%.2f' % args[:amount]
    end
  end

  class Payment
    attr_reader :date, :payment_type, :display_amount, :amount

    def initialize args
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
      @display_amount = '%.2f' % args[:amount]
    end
  end

  def initialize(order)
    @order = order
    @products = build_products_list
    @payments = build_payments_list
  end

  def recipient_adress
    "#{@order.user.full_name}
    #{@order.user.address.capitalize}
    #{@order.user.country}-#{@order.user.npa} #{@order.user.city}
    #{@order.user.country_name}"
  end

  def title
    "Ticket pass"
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
    I18n.t("order.payment_methods.#{@order.payment_method}")
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

  def display_order_id
    @order.order_id.insert(2, " ").insert(8, " ").insert(-3, " ")
  end

  def build_products_list
    products_list = []
    products_list << Product.new(
      description: "Forfait RJ",
      product_number: "5402",
      shipping_date: order_date,
      quantity: @order.product.entries.to_s,
      price: '%.2f' % Records::Rj.ENTRY_PRICE(@order.created_at),
      tva: "-",
      amount: Records::Rj.ENTRY_PRICE(@order.created_at).to_f * @order.product.entries.to_f)

    products_list << Product.new(
      description: "Places pour dormir GARS",
      product_number: "3590",
      shipping_date: order_date,
      quantity: @order.product.man_lodging.to_s,
      price: '%.2f' % Records::Rj::LODGING_PRICE,
      tva: "-",
      amount: Records::Rj::LODGING_PRICE.to_f * @order.product.man_lodging.to_f)

    products_list << Product.new(
      description: "Places pour dormir FILLE",
      product_number: "5230",
      shipping_date: order_date,
      quantity: @order.product.woman_lodging.to_s,
      price: '%.2f' % Records::Rj::LODGING_PRICE,
      tva: "-",
      amount: Records::Rj::LODGING_PRICE.to_f * @order.product.woman_lodging.to_f)

    products_list << Product.new(
      description: "Frais d'inscription",
      product_number: "",
      shipping_date: "",
      quantity: "1",
      price: '%.2f' % Records::Rj::FEE,
      tva: "-",
      amount: Records::Rj::FEE.to_f)

    products_list
  end

  def build_payments_list
    payments_list = []
    payments_list << Payment.new(
      date: order_date,
      payment_type: payment_type,
      amount: ((@order.amount / 100)*-1).to_f
    )

    payments_list << Payment.new(
      date: "",
      payment_type: "Réduction",
      amount: @order.discount_amount.to_f
    )

    payments_list
  end

  def total_products
    '%.2f' % products.inject(0) { |sum, product| sum = sum + product.amount}
  end

  def total
    '%.2f' % (products.inject(0) { |sum, product| sum = sum + product.amount}.to_f + total_payments)
  end

  private

  def total_payments
    payments.inject(0) { |sum, payment| sum = sum + payment.amount}
  end

end
