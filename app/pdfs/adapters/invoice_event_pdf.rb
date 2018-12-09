module Adapters
  class InvoiceEventPdf < Adapters::InvoicePdf
    class Item
      attr_reader :name, :number, :shipping_date, :quantity, :_quantity, 
                  :price, :_price, :tva, 
                  :tot_price, :_tot_price, :price, :sub_info, :order_item

      def initialize order_item
        @order_item = order_item
        item = @order_item.item
        @shipping_date = "-"
        @quantity = order_item.quantity
        @number = @order_item.item.number.to_s
        @_price = @order_item.item.price / ::Payment::FDIV
        @price = "%.2f" % @_price
        @tva = "-"
        @name = @order_item.item.name
        @_quantity = @order_item.quantity
        @quantity = @_quantity.to_s
        @sub_info = "Pass pour #{order_item.firstname} #{order_item.lastname}"
        @_tot_price = @_price * @_quantity
        @tot_price = '%.2f' % @_tot_price
      end
    end

    def initialize(order_event)
      super(order_event)
      @order_event = order_event
    end

    def items
      @order_event.order_items.to_a.map do |order_item|
        Item.new(order_item)
      end << PaymentFee.new(@order.fee)
    end
  end
end
