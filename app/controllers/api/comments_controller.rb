class Api::CommentsController < Api::BaseController

  require_login

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    unless @comment.save
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])
    render_unauthorized unless can_edit?(@comment)
    unless @comment.update_attributes(comment_params)
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:message, :post_id)
  end

end
