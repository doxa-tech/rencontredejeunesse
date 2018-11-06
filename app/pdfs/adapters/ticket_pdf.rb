module Adapters
  class TicketPdf

    def initialize(event_order)
      @event_order = event_order
    end

    def tickets
      @event_order.order_items.to_a.map do |order_item|
        Ticket.new(order_item)
      end
    end

    class Ticket
      attr_reader(
        :title, :subtitle1, :subtitle2, :subtitle3, :dates, :times, 
        :loc1, :loc2, :loc3, :loc4, :price, :orga1, :orga2, :orga3, :orga4, 
        :logo, :issued_for, :main_code, :main_code_str, :sub1_code, :sub2_code, 
        :contact)
      def initialize(order_item)
        @title = order_item.item.name
        @subtitle1 = order_item.item.description
        @subtitle2 = "TODO"
        @subtitle3 = "À présenter le jour de l'événement"
        @dates = "TODO"
        @times = "TODO"
        @loc1 = "Espace-Gruyère"
        @loc2 = "Rue de Vevey 64"
        @loc3 = "1630 Bulle"
        @loc4 = "Suisse"
        @price = "%.2fCHF" % (order_item.item.price / ::Payment::FDIV)
        @orga1 = "Association Rencontre de Jeunesse"
        @orga2 = "1607 Palézieux"
        @orga3 = "Suisse"
        @orga4 = "www.rencontredejeunesse.ch"
        @logo = "orders/pdf/logo.png"
        @issued_for = "#{order_item.firstname} #{order_item.lastname}"
        @main_code = "123455322435"
        @main_code_str = "1"
        @sub1_code = "1"
        @sub2_code = "1"
        @contact = "info@rencontredejeunesse.ch"
      end
    end

  end
end
