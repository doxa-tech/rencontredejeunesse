class Admin::BaseController < ApplicationController
  layout "admin"
  require_login
end
