class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
		if @user.save
      UserMailer.confirmation(@user).deliver_now
			redirect_to root_path, success: "Votre compte RJ Connect a été créé avec succès. Vous avez reçu un email pour confirmer votre compte."
		else
			render 'new'
		end
  end

  private

  def user_params
    params.require(:user).permit(
      :gender, :birthday, :firstname, :lastname, :email, :phone, :address,
      :npa, :city, :country, :newsletter, :password, :password_confirmation
    )
  end

end
