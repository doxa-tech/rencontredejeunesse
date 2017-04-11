class Api::CommentsController < Api::BaseController

  require_login
  before_action :authorized?, only: [:update, :destroy]

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    unless @comment.save
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    unless @comment.update_attributes(comment_params)
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:message, :post_id)
  end

  def authorized?
    @comment = Comment.find(params[:id])
    render_unauthorized unless can_edit?(@comment)
  end

end
