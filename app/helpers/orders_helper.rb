module OrdersHelper

  def postfinance_url
    env = Rails.env.production? ? "prod" : "test"
    return "https://e-payment.postfinance.ch/ncol/#{env}/orderstandard_utf8.asp"
  end

  def items
    unless @items.present?
      order_bundle = OrderBundle.find_by(key: params[:key])
      @items = []
      @items = order_bundle.items.active if order_bundle
    end
    return @items
  end

  def is_invoice_available?(order)
    nearest_date = order.items.pluck(:valid_until).sort.first
    if nearest_date && !Rails.env.test?
      return Date.current < (nearest_date - 1.week)
    else
      return true
    end
  end

end
