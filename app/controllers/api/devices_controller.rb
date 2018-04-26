class Api::DevicesController < Api::BaseController

  def create
    device = Device.find_or_create_by(token: params[:token])
    if device.persisted?
      render json: { id: device.id, token: device.token }
    else
      render json: { errors: device.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
