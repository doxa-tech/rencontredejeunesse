module OrdersHelper

  def postfinance_url
    env = Rails.env.production? ? "prod" : "test"
    return "https://e-payment.postfinance.ch/ncol/#{env}/orderstandard_utf8.asp"
  end

  def items
    unless @items.present?
      order_bundle = OrderBundle.find_by(key: params[:item])
      @items = []
      @items = order_bundle.items.active if order_bundle
    end
    return @items
  end

end
