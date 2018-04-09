module Adapters
  class OrderPassAdapter
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
      raise NotImplementedError
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
end
