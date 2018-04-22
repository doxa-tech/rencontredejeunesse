module Adapters
  class OrderPassRjAdapter < OrderPassAdapter

    def initialize(order)
      super(order)
    end

    def build_products_list
      products_list = []
      entry_price = Records::Rj.ENTRY_PRICE(@order.created_at).to_f
      fee_price = Records::Rj::FEE.to_f
      if @order.volunteer?
        entry_price = 50.to_f
        fee_price = Records::Rj::VOLUNTEER_FEE.to_f
      end

      products_list << Product.new(
        description: "Forfait RJ",
        product_number: "5402",
        shipping_date: order_date,
        quantity: @order.product.entries.to_s,
        price: '%.2f' % entry_price,
        tva: "-",
        amount: entry_price * @order.product.entries.to_f)

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
        price: '%.2f' % fee_price,
        tva: "-",
        amount: fee_price)

      products_list
    end
  end
end
