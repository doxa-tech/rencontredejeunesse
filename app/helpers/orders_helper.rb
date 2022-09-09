module OrdersHelper

  def self.summary(order)
    summary = "#{I18n.l order.created_at, format: :date}"
    summary += " - #{order.bundle.name}" if order.bundle
    summary += " - #{order.amount / 100} CHF"
    summary
  end

  def postfinance_url
    env = Rails.env.production? ? "prod" : "test"
    return "https://e-payment.postfinance.ch/ncol/#{env}/orderstandard_utf8.asp"
  end

  def human_order_status(order)
    I18n.t("order.statuses.#{order.status}")
  end

  def items
    unless @items.present?
      @items = []
      @items = order_bundle.items.active if order_bundle
    end
    return @items
  end

  def order_bundle
    @order_bundle ||= OrderBundle.find_by(key: params[:key])
  end

  def bundle_limit
    order_bundle.limit if order_bundle
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
