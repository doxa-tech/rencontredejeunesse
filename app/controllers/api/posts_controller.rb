class Api::PostsController < Api::BaseController

  def index
    @posts = Post.all
  end

  def create
    post = Post.new(post_params)
    post.user = User.first # TODO
    if post.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:message, :image)
  end

end
