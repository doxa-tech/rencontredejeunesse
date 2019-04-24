class Admin::PostsController < Admin::BaseController
  load_and_authorize

  def index
    @table = Table.new(self, Post, @posts, truncate: false)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.image = Image.new(file: params[:post][:image]) if params[:post][:image]
    @post.user = current_user
    if @post.save
      redirect_to admin_posts_path, success: "Post créé"
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    @post.assign_attributes(post_params)
    @post.image = Image.new(file: params[:post][:image]) if params[:post][:image]
		if @post.save
			redirect_to admin_posts_path, success: "Post mis à jour"
		else
			render 'edit'
		end
  end 

  def destroy
    @post.destroy
		redirect_to admin_posts_path, success: "Post supprimé"
  end

  private

  def post_params
    params.require(:post).permit(:message)
  end

end
