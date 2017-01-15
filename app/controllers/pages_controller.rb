class PagesController < ApplicationController

  def home
    render "index"
  end

  def index
    render "vitrine", layout: "vitrine"
  end

  def login
    render layout: "login"
  end

  def dashboard
    render layout: "admin"
  end

end
