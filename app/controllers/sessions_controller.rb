class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.where("lower(email) = ?", params[:session][:email].strip.downcase).first
    if @user && @user.authenticate(params[:session][:password])
      sign_in @user, permanent: params[:session][:remember_me] == "1"
      redirect_back_or dashboard_path, success: "Connexion réussie"
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
end
