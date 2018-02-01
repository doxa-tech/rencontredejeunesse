class SessionsController < ApplicationController
  before_action :redirect_if_connected, except: :destroy

  def new
  end

  def create
    @user = User.where("lower(email) = ?", params[:session][:email].strip.downcase).first
    if @user && @user.authenticate(params[:session][:password])
      sign_in @user, permanent: params[:session][:remember_me] == "1"
      redirect_back_or(redirect_url, success: "Connexion réussie")
    else
      flash.now[:error] = "Nom d'utilisateur et/ou mot de passe incorrect(s)"
      render 'new'
    end
  end

  def destroy
    require_login!
    sign_out
    redirect_to signin_path, success: "Déconnexion réussie"
  end

  private

  def redirect_if_connected
    redirect_to connect_root_path if signed_in?
  end

  def redirect_url
    params[:redirect_url] || connect_root_path
  end
end
