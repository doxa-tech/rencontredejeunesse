class Admin::BaseController < ApplicationController
  layout "admin"
  require_login

  def index
  end
  
end
