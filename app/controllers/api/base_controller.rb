class Api::BaseController < ActionController::API
  # Adeia
  include Adeia::Helpers::SessionsHelper
  include Adeia::ControllerMethods

  #
  # helpers methods
  #

  helper_method :can_edit?

  def can_edit?(resource)
    if current_user && (resource.user == current_user || current_user.belongs_to?(:communication))
      return true
    end
    return false
  end

  def render_unauthorized
    render json: { errors: ["Authorization failed."] }, status: :unauthorized
  end

  def render_unauthenticated
    render json: { errors: ["Authentification failed."] }, status: :unauthorized
  end

  #
  # adeia
  #

  # Adeia: redirect the cookies to params. Necessary for #current_user.
  def cookies
    params
  end

  rescue_from Adeia::AccessDenied do |exception|
    render_unauthorized
  end

  rescue_from Adeia::LoginRequired do |exception|
    render_unauthenticated
  end

end
