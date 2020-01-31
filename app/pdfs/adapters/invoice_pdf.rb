module Adapters
  class InvoicePdf
    include OrdersHelper

    class Item
      attr_reader :name, :number, :shipping_date, :quantity, :_quantity, 
                  :price, :_price, :tva, 
                  :tot_price, :_tot_price, :price, :sub_info, :order_item

      def initialize order_item
        @order_item = order_item
        item = @order_item.item
        @shipping_date = "-"
        @_quantity = order_item.quantity
        @quantity = @_quantity.to_s
        @number = @order_item.item.number.to_s
        @_price = @order_item.item.price / ::Payment::FDIV
        @price = "%.2f" % @_price
        @tva = "-"
        @name = @order_item.item.name
        
        @sub_info = "Pass à imprimer soi-même"
        @_tot_price = @_price * @_quantity
        @tot_price = '%.2f' % @_tot_price
      end
    end

    class PaymentFee
      attr_reader :name, :number, :shipping_date, :quantity, :_quantity, 
                  :price, :_price, :tva, 
                  :tot_price, :_tot_price, :price, :sub_info, :order_item
      
      def initialize amount
        @name = "Frais de paiement"
        @number = "-"
        @shipping_date = "-"
        @_quantity = 1
        @quantity = @_quantity.to_s
        @tva = "-"
        @_tot_price = amount / ::Payment::FDIV
        @tot_price = '%.2f' % @_tot_price
        @_price = amount / ::Payment::FDIV
        @price = '%.2f' % @_price
        @sub_info = ""
      end
    end

    class Payment
      attr_reader :time, :payment_type, :display_amount, :amount, :_amount

      def initialize amount, time, payment_type, method
        @time = time.nil? ? "-" : time.strftime("%d.%m.%Y")
        @_amount = amount / ::Payment::FDIV
        @amount = '%.2f' % @_amount
        if payment_type.nil?
          @payment_type = method
        else
          @payment_type = I18n.t("payment.method." + method) + " (" +I18n.t("payment.payment_types."+ payment_type).downcase + ")"
        end
      end
    end

    def initialize(order)
      @order = order
    end

    def items
      @order.order_items.to_a.map do |order_item|
        Item.new(order_item)
      end << PaymentFee.new(@order.fee)
    end

    def payments
      payments = @order.payments.where("status=?", 9).to_a.map do |payment|
        Payment.new(payment.amount, payment.time, 
                    payment.payment_type, payment.method)
      end
      if @order.discount_amount > 0
        payments << Payment.new(@order.discount_amount, @order.created_at,
          nil, "Réduction")
      end
      payments
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
      @order.user.full_name.truncate(30)
    end

    def shipping_type
      "print@home"
    end

    def status
      human_order_status(@order)
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
      items.inject(0) { |sum, item| sum = sum + item._price*item._quantity}
    end

    def _total_payments
      payments.inject(0) { |sum, payment| sum = sum + payment._amount}
    end

  end
end
