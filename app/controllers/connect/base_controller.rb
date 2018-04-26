class Connect::BaseController < ApplicationController
  before_action :sign_in_with_token, :check_if_signed_in, :check_if_confirmed

  layout "connect"

  private

  def check_if_confirmed
    # TODO: different formats supported
    render "connect/unconfirmed" unless current_user.confirmed
  end

  def sign_in_with_token
    if params[:remember_token] && user = User.find_by_remember_token(params[:remember_token])
      sign_in(user)
    end
  end
end
