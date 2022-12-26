
PostFinanceCheckout.configure do |config|
    config.user_id = Rails.application.secrets.postfinance_user_id
    config.authentication_key = Rails.application.secrets.postfinance_user_key
end
