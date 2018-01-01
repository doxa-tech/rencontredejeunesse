class UsersController < ApplicationController
  layout "admin", except: [:new, :create]
  require_login except: [:new, :create]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
		if @user.save
      # TODO: EMAIL
      sign_in @user
			redirect_to dashboard_path, success: "Bienvenue sur le RJ Connect"
		else
			render 'new'
		end
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
    params.require(:user).permit(
      :gender, :birthday, :firstname, :lastname, :email, :phone, :address,
      :npa, :city, :country, :newsletter, :password, :password_confirmation, :current_password
    )
  end

end
