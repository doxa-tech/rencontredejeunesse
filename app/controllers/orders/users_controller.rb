class Orders::UsersController < Orders::BaseController
  before_action :check_if_signed_in, only: [:new, :create, :signin]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
		if @user.save
      UserMailer.confirmation(@user).deliver_now
			redirect_to controller: "orders/#{params[:product]}", action: "new"
		else
			render 'new'
		end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      sign_in @user
      redirect_to confirmation_orders_login_path(params[:id]), success: "Utilisateur mis à jour"
    else
      render 'edit'
    end
  end

  def signin
    @user = User.with_account.where("lower(email) = ?", params[:session][:email].strip.downcase).first
    if @user && @user.authenticate(params[:session][:password])
      sign_in @user
      redirect_to controller: "orders/#{params[:product]}", action: "new"
    else
      flash.now[:error] = "Nom d'utilisateur et/ou mot de passe incorrect(s)"
      render 'new'
    end
  end

  private

  def check_if_signed_in
    redirect_to controller: "orders/#{params[:product]}", action: "new" if signed_in?
  end

  def user_params
    params.require(:user).permit(
      :gender, :birthday, :firstname, :lastname, :email, :phone, :address,
      :npa, :city, :country, :newsletter, :password, :password_confirmation
    )
  end

end
