module Orders

  class Event < Order
    
    validates :registrants, presence: true
    validate :number_of_registrants

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

    def bundle
      @bundle ||= OrderBundle.joins(items: :registrations).where(items: { orders: { id: self.id } }).first
    end

    private

    def number_of_registrants
      if bundle && bundle.limit && self.registrants.size > bundle.limit
        errors.add(:base, "Il ne doit pas y avoir plus de #{bundle.limit} article(s).")
      end
    end

  end

end