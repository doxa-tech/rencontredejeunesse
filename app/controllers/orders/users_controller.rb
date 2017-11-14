class Orders::UsersController < Orders::BaseController
  before_action :validate_product
  before_action :check_if_signed_in

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
		if @user.save
      # TODO: EMAIL
      sign_in @user
			redirect_to controller: "orders/#{@product}", action: "new"
		else
			render 'new'
		end
  end

  def signin
    @user = User.with_account.where("lower(email) = ?", params[:session][:email].strip.downcase).first
    if @user && @user.authenticate(params[:session][:password])
      sign_in @user
      redirect_to controller: "orders/#{@product}", action: "new"
    else
      flash.now[:error] = "Nom d'utilisateur et/ou mot de passe incorrect(s)"
      render 'new'
    end
  end

  private

  def check_if_signed_in
    redirect_to controller: "orders/#{@product}", action: "new" if signed_in?
  end

  def validate_product
    if ["login", "rj"].include? params[:product]
      @product = params[:product]
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def user_params
    params.require(:user).permit(
      :gender, :birthday, :firstname, :lastname, :email, :phone, :address,
      :npa, :city, :country, :newsletter, :password, :password_confirmation
    )
  end

end
