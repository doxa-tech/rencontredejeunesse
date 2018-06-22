module Orders

  class Event < Order

    default_scope { where(order_type: :event) }

    def order_items
      registrants
    end

  end

end