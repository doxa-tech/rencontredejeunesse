class Api::PostsController < Api::BaseController

  def index
    @posts = Post.all
  end

  def create
    @post = Post.new(post_params)
    @post.user = User.find_by_remember_token(params[:remember_token])
    unless @post.save
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:message, :image_id)
  end

end
