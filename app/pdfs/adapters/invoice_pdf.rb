module Adapters
  class InvoicePdf
    attr_reader :items, :payments

    class Item
      attr_reader :name, :number, :shipping_date, :quantity, :price, :tva, :display_price, :price

      def initialize order_item
        item = order_item.item
        item.attributes.each do |k,v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end
        @display_price = '%.2f' % (item["price"] / ::Payment::FDIV)
        @shipping_date = "-"
        @quantity = order_item.quantity.to_s
        @number = @number.to_s
        @price = (@price / ::Payment::FDIV).to_f
        @tva = "-"
      end
    end

    class Payment
      attr_reader :time, :payment_type, :display_amount, :amount

      def initialize args
        args.each do |k,v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end
        @display_amount = '%.2f' % (args["amount"] / 100)
        @time = "TODO-TIME"
        @amount = @amount.to_f
      end
    end

    def initialize(order)
      @order = order
    end

    def items
      @order.order_items.to_a.map do |order_item|
        Item.new(order_item)
      end
    end

    def payments
      @order.payments.to_a.map do |payment|
        Payment.new(payment.attributes)
      end
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
      @order.order_id.to_s
    end

    def reference_person
      @order.user.full_name
    end

    def shipping_type
      "PDF"
    end

    def payment_type
      if @order.payments.size > 2
        I18n.t("payment.method.multiple")
      else
        I18n.t("payment.method.#{@order.payments.last.method}")
      end
    end

    def currency
      "CHF"
    end

    def shipping_adress
      @order.user.email
    end

    def order_id
      @order.order_id.to_s
    end

    def display_order_id
      order_id.insert(2, " ").insert(8, " ").insert(-3, " ")
    end

    def build_items_list
      items_list = []
      items_list << Product.new(
        description: "Forfait Login",
        product_number: "5502",
        shipping_date: order_date,
        quantity: @order.product.entries.to_s,
        price: '%.2f' % Records::Login::ENTRY_PRICE,
        tva: "-",
        amount: Records::Login::ENTRY_PRICE.to_f * @order.product.entries.to_f)

      items_list << Product.new(
        description: "Frais d'inscription",
        product_number: "",
        shipping_date: "",
        quantity: "1",
        price: '%.2f' % Records::Login::FEE,
        tva: "-",
        amount: Records::Login::FEE.to_f)

      items_list
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
        amount: ((@order.discount_amount / 100)*-1).to_f
      )

      payments_list
    end

    def total_items
      '%.2f' % _total_items
    end

    def total
      '%.2f' % (_total_items + _total_payments)
    end

    private

    def _total_items
      @order.items.inject(0) { |sum, item| sum = sum + item.price} / ::Payment::FDIV
    end

    def _total_payments
      @order.payments.inject(0) { |sum, payment| sum = sum + payment.amount} / ::Payment::FDIV
    end

  end
end
