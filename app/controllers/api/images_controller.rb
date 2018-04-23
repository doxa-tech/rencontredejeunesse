class Api::ImagesController < Api::BaseController

  def create
    io = request.body
    def io.original_filename
      "img_#{Time.now.to_i}.jpg"
    end
    image = Image.new
    image.file = io
    if image.save
      render json: { id: image.id }
    else
      render json: { errors: image.errors.full_messages }, status: :unprocessable_entity
    end
  end


end
