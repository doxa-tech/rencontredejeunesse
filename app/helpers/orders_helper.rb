module OrdersHelper

  def postfinance_url
    env = Rails.env.production? ? "prod" : "test"
    return "https://e-payment.postfinance.ch/ncol/#{env}/orderstandard_utf8.asp"
  end

  def beds_price(record)
    (record.girl_beds + record.boy_beds) * Records::Rj::BED_PRICE
  end

  def entries_price(record)
    record.entries * Records::Rj.ENTRY_PRICE(record.created_at)
  end

end
