class Users::VerificationController < ApplicationController

  # send confirmation link
  def create

  end

  # confirm an account
  def update
    user = User.find_by(verify_token: params[:token])
    user.update_attribute(confirmed: true) if user
    redirect_to root_path, success: "Ton compte est maintenant confirmé !"
  end

end
