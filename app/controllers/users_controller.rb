class UsersController < ApplicationController
  layout "admin"
  require_login

  def index
  end

  def edit
  end

  def update
    if current_user.update_with_password(user_params)
      sign_in current_user
      redirect_to edit_path, success: "Compte mis à jour"
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:gender, :birthday, :firstname, :lastname, :email, :phone, :address, :npa, :city, :country, :newsletter, :password, :password_confirmation, :current_password)
  end

end
