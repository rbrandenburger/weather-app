class ReadingsController < ApplicationController
  UnauthorizedError = Class.new(StandardError)

  before_action :authorize_api_key, except: [:show]

  rescue_from UnauthorizedError, with: :unauthorized_response

  def create
    reading = StationReading.new(
      celcius_temp: params[:temp_c],
      relative_humidity: params[:relative_humidity],
      recorded_on: params[:recorded_on]
    )

    status = reading.save ? 201 : 400

    render body: nil, status: status
  end

  def show
    render Views::Dashboard.new
  end

  private

  def authorize_api_key
    return if request.headers.to_h["HTTP_X_API_KEY"] == ENV["DEVICE_API_KEY"]

    raise UnauthorizedError
  end

  def unauthorized_response
    render body: nil, status: 403
  end
end
