module Adapters
  class OrderPassLoginAdapter < OrderPassAdapter

    def initialize(order)
      super(order)
    end

    def build_products_list
      products_list = []
      products_list << Product.new(
        description: "Forfait Login",
        product_number: "5502",
        shipping_date: order_date,
        quantity: @order.product.entries.to_s,
        price: '%.2f' % Records::Login::ENTRY_PRICE,
        tva: "-",
        amount: Records::Login::ENTRY_PRICE.to_f * @order.product.entries.to_f)

      products_list << Product.new(
        description: "Frais d'inscription",
        product_number: "",
        shipping_date: "",
        quantity: "1",
        price: '%.2f' % Records::Login::FEE,
        tva: "-",
        amount: Records::Rj::Login.to_f)

      products_list
    end
  end
end
