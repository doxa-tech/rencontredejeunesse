class Api::PostsController < Api::BaseController
  include ActionView::Helpers::TextHelper

  def index
    @posts = Post.includes(:comments, :user, :image).paginate(page: params[:page], per_page: 10)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user)
    render json: { errors: ["Post not found."] }, status: :not_found if @post.nil?
  end

  def create
    authorize!
    @post = Post.new(post_params)
    @post.user = User.find_by_remember_token(params[:remember_token])
    if @post.save
      message = truncate @post.message, length: 100
      send_push_notifications(message)
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @post = load_and_authorize!
    unless @post.update_attributes(post_params)
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @post = load_and_authorize!
    @post.destroy
  end

  private

  def send_push_notifications(message)
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name("RJ")
    n.registration_ids = Device.pluck(:token)
    n.notification = { body: message }
    n.save!
    Rpush.push
    Rpush.apns_feedback
  end

  def post_params
    params.require(:post).permit(:message, :image_id)
  end

end
