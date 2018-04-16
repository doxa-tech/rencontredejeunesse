module Adapters
  class OrderPassRjAdapter < OrderPassAdapter

    def initialize(order)
      super(order)
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
  end
end
