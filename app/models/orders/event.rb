module Orders

  class Event < Order
    
    validates :registrants, presence: true

    def order_items
      registrants
    end

    def items
      tickets
    end

    def invoice_pdf_adapter
      Adapters::InvoiceEventPdf.new(self)
    end

    def ticket_pdf_adapter
      Adapters::TicketPdf.new(self)
    end

    def order_type
      :event
    end

  end

end