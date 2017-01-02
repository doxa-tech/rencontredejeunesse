class PagesController < ApplicationController

  def index
    # render "vitrine"
  end

  def login
    render layout: "login"
  end

  def dashboard
    render layout: "admin"
  end

end
