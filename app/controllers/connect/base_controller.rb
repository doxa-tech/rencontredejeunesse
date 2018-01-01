class Connect::BaseController < ApplicationController
  before_action :check_if_signed_in # defined in ApplicationController
  before_action :check_if_confirmed

  layout "connect"

  private

  def check_if_confirmed
    render "connect/unconfirmed" unless current_user.confirmed
  end
end
