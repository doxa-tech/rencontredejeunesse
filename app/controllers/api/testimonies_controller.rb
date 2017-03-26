class Api::TestimoniesController < Api::BaseController

  def index
    @testimonies = Testimony.includes(:user)
  end

  def create
    @testimony = Testimony.new(testimony_params)
    @testimony.user = User.find_by_remember_token(params[:remember_token])
    unless @testimony.save
      render json: { errors: @testimony.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def testimony_params
    params.require(:testimony).permit(:message)
  end
end
