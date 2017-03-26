class Api::CommentsController < Api::BaseController

  def create
    @comment = Comment.new(comment_params)
    @comment.user = User.find_by_remember_token(params[:remember_token])
    unless @comment.save
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:message, :post_id)
  end

end
