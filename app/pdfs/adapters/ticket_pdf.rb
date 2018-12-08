module Adapters
  class TicketPdf

    def initialize(event_order)
      @event_order = event_order
    end

    def tickets
      @event_order.order_items.to_a.map do |order_item|
        Ticket.new(order_item, @event_order)
      end
    end

    class Ticket
      attr_reader(
        :title, :subtitle1, :subtitle2, :subtitle3, :dates, :times, :upinfo,
        :loc1, :loc2, :loc3, :loc4, :price, :orga1, :orga2, :orga3, :orga4, 
        :logo, :issued_for, :main_code, :main_code_str, :sub1_code, :sub2_code, 
        :contact)
      def initialize(order_item, event_order)
        options = order_item.item.order_bundle.options || {}
        @upinfo = options.fetch("upinfo", "")
        @title = order_item.item.name
        @subtitle1 = options.fetch("subtitle1", order_item.item.description)
        @subtitle2 = options.fetch("subtitle2", order_item.item.order_bundle.name)
        @subtitle3 = options.fetch("subtitle3", "")
        @dates = options.fetch("dates", "")
        @times = options.fetch("times", "")
        @loc1 = options.fetch("loc1", "")
        @loc2 = options.fetch("loc2", "")
        @loc3 = options.fetch("loc3", "")
        @loc4 = options.fetch("loc4", "")
        @price = "%.2fCHF" % (order_item.item.price / ::Payment::FDIV)
        @orga1 = options.fetch("orga1", "")
        @orga2 = options.fetch("orga2", "")
        @orga3 = options.fetch("orga3", "")
        @orga4 = options.fetch("orga4", "")
        @logo = options.fetch("logo", "orders/pdf/ticket/default.png") #"orders/pdf/logo.png"
        @issued_for = "#{order_item.firstname} #{order_item.lastname}"
        @main_code = order_item.ticket_id.to_s
        @main_code_str = order_item.ticket_id.to_s
        @sub1_code = options.fetch("sub1_code", "")
        @sub2_code = event_order.order_id.to_s
        @contact = options.fetch("contact", "")
      end
    end

  end
end
