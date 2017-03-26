class Api::BaseController < ActionController::API
  # Adeia
  include Adeia::Helpers::SessionsHelper
  include Adeia::ControllerMethods

  # Adeia: redirect the cookies to params. Necessary for #current_user.
  def cookies
    params
  end

  rescue_from Adeia::AccessDenied do |exception|
    render json: { errors: ["Authorization failed."] }, status: :unauthorized
  end

  rescue_from Adeia::LoginRequired do |exception|
    render json: { errors: ["Authentification failed."] }, status: :unauthorized
  end

end
