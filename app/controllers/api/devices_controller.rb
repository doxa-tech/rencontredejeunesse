class Api::DevicesController < Api::BaseController

  def create
    token = params[:platform] == "iOS" ? convert_apn_to_fcm(params[:token]) : params[:token]
    device = Device.new(token: token, platform: params[:platform])
    if device.save
      render json: { id: device.id, token: device.token }
    else
      render json: { errors: device.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def convert_apn_to_fcm(token)
    response = RestClient.post("https://iid.googleapis.com/iid/v1:batchImport",
      payload(token),
      headers
    )
    if response.code == 200
      result = JSON.parse(response.body)["results"][0]
      return result["registration_token"] if result["status"] == "OK"
    end
  end

  def payload(token)
    return {
      application: "com.id1lnx0as1aunq3r129xr5d",
      sandbox: Rails.env.development?,
      apns_tokens: [token]
    }.to_json
  end

  def headers
    return {
      Authorization: "key=" + Rails.application.secrets.fcm_server_key,
      content_type: "application/json"
    }
  end
end
