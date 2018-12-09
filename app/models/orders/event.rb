module Orders

  class Event < Order
    
    validate :number_of_registrants, if: :limited

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

    private

    def number_of_registrants
      if self.registrants.size > 1
        self.errors.add(:base, "Il ne doit pas y avoir plus d'un article.")
      end
    end

  end

end