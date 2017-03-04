class Admin::UsersController < Admin::BaseController

  def index
		@table = Table.new(self, User, User.with_password)
		@table.respond
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to admin_users_path, success: "Utilisateur créé"
		else
			render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			redirect_to admin_users_path, success: "Utilisateur mis à jour"
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		redirect_to admin_users_path, success: "Utilisateur supprimé"
	end

  private

  def user_params
    params.require(:user).permit(:gender, :birthday, :firstname, :lastname, :email, :phone, :address, :npa, :city, :country, :newsletter, :password, :password_confirmation)
  end

end
