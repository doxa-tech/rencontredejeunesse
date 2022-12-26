class Users::VerificationController < ApplicationController
  before_action :check_if_signed_in, only: :new # defined in ApplicationController

  # send confirmation link
  def new
    UserMailer.confirmation(current_user).deliver_now
    redirect_to connect_root_path, success: "Email envoyé"
  end

  # confirm an account
  def edit
    user = User.find_by(verify_token: params[:id])
    unless user.nil?
      user.update_attribute(:confirmed, true)
      redirect_to connect_root_path, success: "Ton compte est maintenant confirmé !"
    else
      redirect_to connect_root_path, error: "Lien invalide"
    end
  end

end
