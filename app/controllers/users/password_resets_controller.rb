class Users::PasswordResetsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    unless user.nil?
      user.reset_token =  SecureRandom.urlsafe_base64
      user.reset_sent_at = Time.zone.now
      user.save!
      UserMailer.password_reset(user).deliver_now
    end
    redirect_to root_path, success: "Un email avec les instructions t'a été envoyé"
  end

  def edit
    @user = User.find_by_reset_token(params[:id])
  end

  def update
    @user = User.find_by_reset_token(params[:id])
    @user.assign_attributes(user_params)
    if @user.reset_sent_at < 2.hours.ago
	    redirect_to new_users_password_reset_path, :error => "La demande pour un nouveau mot de passe a expiré"
	  elsif @user.valid?(:reset)
      @user.reset_token = nil
      @user.reset_sent_at = nil
      @user.save!
      redirect_to root_path, success: "Mot de passe changé"
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
