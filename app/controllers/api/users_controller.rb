class Api::UsersController < Api::BaseController

  def show
    @user = User.find_by_remember_token(params[:id])
    render json: { errors: ["User not found."] }, status: :not_found if @user.nil?
  end

  def signin
    @user = User.where("lower(email) = ?", params[:user][:email].strip.downcase).first
    unless @user && @user.authenticate(params[:user][:password])
      render json: { errors: ["Failed to authenticate user."] }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:gender, :firstname, :lastname, :email, :password, :password_confirmation, :image_id)
  end

end
