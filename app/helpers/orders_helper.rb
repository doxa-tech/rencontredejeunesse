module OrdersHelper

  def postfinance_url
    env = Rails.env.production? ? "prod" : "test"
    return "https://e-payment.postfinance.ch/ncol/#{env}/orderstandard_utf8.asp"
  end

end
