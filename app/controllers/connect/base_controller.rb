class Connect::BaseController < ApplicationController
  before_action :check_if_signed_in

  layout "connect"

  private

  def check_if_signed_in
    redirect_to signin_path, error: "Merci de te connecter avec ton compte RJ" unless signed_in?
  end
end
