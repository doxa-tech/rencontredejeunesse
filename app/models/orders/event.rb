module Orders

  class Event < Order

    ORDER_TYPE = "event"

    validates_with BundleValidator

    default_scope { where(order_type: :event) }

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

  end

end