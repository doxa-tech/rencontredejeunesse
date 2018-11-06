module OrdersHelper

  def postfinance_url
    env = Rails.env.production? ? "prod" : "test"
    return "https://e-payment.postfinance.ch/ncol/#{env}/orderstandard_utf8.asp"
  end

  def items
    order_bundle = OrderBundle.find_by(key: params[:item])
    if order_bundle
      @items ||= order_bundle.items
    else
      @items ||= Item.active.where(key: params[:item])
    end
  end

end
