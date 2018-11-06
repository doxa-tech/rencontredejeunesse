module Adapters
  class InvoiceEventPdf < Adapters::InvoicePdf
    class Item
      attr_reader :name, :number, :shipping_date, :quantity, :price, :tva, 
                  :tot_price, :price, :sub_info, :order_item

      def initialize order_item
        @order_item = order_item
        item = @order_item.item
        @shipping_date = "-"
        @quantity = order_item.quantity
        @number = @order_item.item.number.to_s
        @price = "%.2f" % (@order_item.item.price / ::Payment::FDIV)
        @tva = "-"
        @name = @order_item.item.name
        @quantity = @order_item.quantity.to_s
        @sub_info = "Pass pour #{order_item.firstname} #{order_item.lastname}"
        @tot_price = '%.2f' % (@order_item.item.price*@order_item.quantity / ::Payment::FDIV)
      end
    end

    def initialize(order_event)
      super(order_event)
      @order_event = order_event
    end

    def items
      @order_event.order_items.to_a.map do |order_item|
        Item.new(order_item)
      end
    end
  end
end
