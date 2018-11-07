module Adapters
  class InvoicePdf

    class Item
      attr_reader :name, :number, :shipping_date, :quantity, :price, :tva, 
                  :tot_price, :price, :sub_info, :order_item

      def initialize order_item
        @order_item = order_item
        item = @order_item.item
        # item.attributes.each do |k,v|
        #   instance_variable_set("@#{k}", v) unless v.nil?
        # end
        @shipping_date = "-"
        @quantity = order_item.quantity
        @number = @order_item.item.number.to_s
        @price = "%.2f" % (@order_item.item.price / ::Payment::FDIV)
        @tva = "-"
        @name = @order_item.item.name
        @quantity = @order_item.quantity.to_s
        @sub_info = "Pass à imprimer sois-même"
        @tot_price = '%.2f' % (@order_item.item.price*@order_item.quantity / ::Payment::FDIV)
      end
    end

    class Payment
      attr_reader :time, :payment_type, :display_amount, :amount

      def initialize payment
        @display_amount = '%.2f' % (payment["amount"] / 100)
        @time = payment.time.nil? ? "-" : payment.time.strftime("%d.%m.%Y")
        @amount = @amount.to_f
        @payment_type = "#{payment.method} (#{I18n.t('payment.type.'+ payment.payment_type).downcase})"
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
        Payment.new(payment)
      end
    end

    def recipient_adress
      "#{@order.user.full_name}
      #{@order.user.address.capitalize}
      #{@order.user.country}-#{@order.user.npa} #{@order.user.city}
      #{@order.user.country_name}"
    end

    def title
      "Facture"
    end

    def order_date
      @order.created_at.strftime("%d.%m.%Y")
    end

    def client_id
      "-"
    end

    def reference_person
      @order.user.full_name
    end

    def shipping_type
      "print@home"
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
      "-"
    end

    def order_id
      @order.order_id.to_s
    end

    def display_order_id
      order_id.insert(2, " ").insert(8, " ").insert(-3, " ")
    end

    def total_items
      '%.2f' % _total_items
    end

    def total
      '%.2f' % (_total_items - _total_payments)
    end

    private

    def _total_items
      items.inject(0) { |sum, item| sum = sum + item.order_item.item.price*item.order_item.quantity} / ::Payment::FDIV
    end

    def _total_payments
      @order.payments.inject(0) { |sum, payment| sum = sum + payment.amount} / ::Payment::FDIV
    end

  end
end
