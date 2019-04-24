class Admin::CommentsController < Admin::BaseController
  load_and_authorize

  def edit
  end

  def update
    if @comment.update_attributes(comment_params)
      redirect_to admin_post_path(@comment.post)
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    redirect_to admin_post_path(@comment.post)
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

end
