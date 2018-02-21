module OrdersHelper

  def postfinance_url
    env = Rails.env.production? ? "prod" : "test"
    return "https://e-payment.postfinance.ch/ncol/#{env}/orderstandard_utf8.asp"
  end

  def lodging_price(record)
    (record.man_lodging + record.woman_lodging) * Records::Rj::LODGING_PRICE
  end

  def entries_price(record)
    record.entries * Records::Rj.ENTRY_PRICE(record.created_at)
  end

  def human_status(order)
    if order.paid?
      "Payé"
    else
      "Non payé"
    end
  end

end
