class ApplicationController < ActionController::Base
  include ExceptionsHandler
  include ApplicationHelper

  protect_from_forgery with: :exception

  add_flash_types :success, :error


  private

  def check_if_signed_in
    redirect_to signin_path, error: "Merci de te connecter avec ton compte RJ" unless signed_in?
  end
end
