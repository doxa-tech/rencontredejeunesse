class Api::TestimoniesController < Api::BaseController

  require_login only: :create
  before_action :authorized?, only: [:update, :destroy]

  def index
    @testimonies = Testimony.where("created_at > ?", Date.new(2019, 05, 01)).includes(:user).paginate(page: params[:page], per_page: 10)
  end

  def create
    @testimony = Testimony.new(testimony_params)
    @testimony.user = User.find_by_remember_token(params[:remember_token])
    unless @testimony.save
      render json: { errors: @testimony.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    unless @testimony.update_attributes(testimony_params)
      render json: { errors: @testimony.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @testimony.destroy
  end

  private

  def testimony_params
    params.require(:testimony).permit(:message)
  end

  def authorized?
    @testimony = Testimony.find(params[:id])
    render_unauthorized unless can_edit?(@testimony)
  end

end
