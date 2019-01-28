class Orders::UsersController < Orders::BaseController
  before_action :check_if_signed_in, only: [:new, :create]
  before_action :check_if_not_signed_in, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params new_record: true)
		if @user.save
      UserMailer.confirmation(@user).deliver_now
      sign_in @user
			redirect_to new_orders_event_path(key: params[:key])
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
      redirect_to confirmation_orders_event_path(params[:id]), success: "Utilisateur mis à jour"
    else
      render 'edit'
    end
  end

  private

  def check_if_signed_in
    redirect_to new_orders_event_path(key: params[:key]) if signed_in?
  end

  def user_params(new_record: false)
    attributes = [
      :gender, :birthday, :firstname, :lastname, :phone, :address,
      :npa, :city, :country, :newsletter
    ]
    attributes.push(:email, :password, :password_confirmation) if new_record
    params.require(:user).permit(attributes)
  end

end
