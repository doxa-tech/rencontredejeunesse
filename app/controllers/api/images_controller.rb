class Api::ImagesController < Api::BaseController

  def create
    image = Image.new
    image.file = request.body
    if image.save
      render json: { id: image.id }
    else
      render json: {}, status: :unprocessable_entity
    end
  end


end
