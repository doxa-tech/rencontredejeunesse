class Api::UsersController < Api::BaseController

  def show
    @user = User.find_by_remember_token(params[:id])
    render json: { errors: ["User not found."] }, status: :not_found if @user.nil?
  end

  def create
    puts "DAaaaa"
    @user = User.new(user_params)
    unless @user.save(context: :account_setup)
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by_remember_token(params[:id])
    @user.assign_attributes(user_params)
    unless @user.save(context: :account_update)
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def signin
    @user = User.with_account.where("lower(email) = ?", params[:user][:email].strip.downcase).first
    unless @user && @user.authenticate(params[:user][:password])
      render json: { errors: ["Failed to authenticate user."] }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:gender, :firstname, :lastname, :email, :password, :password_confirmation, :image_id)
  end

end
