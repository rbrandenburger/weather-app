class ReadingsController < ActionController::API
  before_action :authorize_api_key, except: [:latest]

  def create
    reading = StationReading.new(
      celcius_temp: params[:temp_c],
      relative_humidity: params[:relative_humidity],
      recorded_on: params[:recorded_on]
    )

    status = reading.save ? 201 : 400

    render body: nil, status: status
  end

  def latest
    body = StationReading.order(:recorded_on).last.as_json
    
    body["farenheit_temp"] = (body["celcius_temp"] * 1.8) + 32.0

    render json: body, status: 200
  end

  private

  def authorize_api_key
    return if request.headers.to_h["HTTP_X_API_KEY"] == ENV["DEVICE_API_KEY"]

    raise UnauthorizedError
  end
end
