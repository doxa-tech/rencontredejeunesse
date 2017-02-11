class ApplicationController < ActionController::Base
  include ExceptionsHandler
  include ApplicationHelper

  protect_from_forgery with: :exception

  add_flash_types :success, :error
end
