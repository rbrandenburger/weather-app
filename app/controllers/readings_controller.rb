class ReadingsController < ApplicationController
  before_action :authorize_api_key

  def create
    reading = StationReading.new(
      celcius_temp: params[:temp_c],
      relative_humidity: params[:relative_humidity],
      recorded_on: params[:recorded_on]
    )

    status = reading.save ? 201 : 401

    render body: nil, status: status
  end

  private

  def authorize_api_key
    return if request.headers.to_h["HTTP_X_API_KEY"] == ENV["DEVICE_API_KEY"]

    raise UnauthorizedError
  end
end
