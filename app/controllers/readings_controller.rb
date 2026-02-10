class ReadingsController < ApplicationController
  UnauthorizedError = Class.new(StandardError)

  before_action :authorize_api_key, except: [:show]
 
  # Skip CSRF for API actions
  skip_before_action :verify_authenticity_token, only: [:create]

  rescue_from UnauthorizedError, with: :unauthorized_response

  def create
    reading = StationReading.new(
      celsius_temp: params[:temp_c],
      relative_humidity: params[:relative_humidity],
      recorded_on: params[:recorded_on]
    )

    status = reading.save ? 201 : 400

    render body: nil, status: status
  end

  def show
    today = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day

    current_weather = {
      "current_temp" => StationReading.order(recorded_on: :desc).first,
      "highest_temp" => StationReading.where(recorded_on: today).order(celsius_temp: :desc).first,
      "lowest_temp" => StationReading.where(recorded_on: today).order(celsius_temp: :asc).first
    }

    period_forecast = Api::NwsUtility.get_period_forecast
    hourly_forecast = Api::NwsUtility.get_hourly_forecast
    sunrise_sunset = Api::SunriseSunsetUtility.get_sunrise_sunset

    render Views::Dashboard.new(
      current_weather: current_weather,
      forecast: {
        "periods" => period_forecast["periods"][0..3],
        "daily" => format_daily_forecast(period_forecast["periods"]),
        "hourly" => format_hourly_forecast(hourly_forecast["periods"]),
        "sun_info" => sunrise_sunset
      }
    )
  end

  private

  def authorize_api_key
    return if request.headers.to_h["HTTP_X_API_KEY"] == ENV["DEVICE_API_KEY"]

    raise UnauthorizedError
  end

  def unauthorized_response
    render body: nil, status: 403
  end

  def format_daily_forecast(periods)
    # Group the 12-hour periods by the actual calendar date
    daily_groups = periods.group_by { |period| Date.parse(period["startTime"]) }

    daily_groups.map do |date, day_periods|
      # NWS separates Highs and Lows into 'isDaytime: true' and 'isDaytime: false'
      high_period = day_periods.find { |p| p["isDaytime"] == true }
      low_period = day_periods.find { |p| p["isDaytime"] == false }

      {
        "date" => date.strftime("%A"),
        "icon" => high_period ? high_period&.dig("icon") : low_period.dig("icon"),
        "high" => high_period&.dig("temperature") || "--",
        "low" => low_period&.dig("temperature") || "--",
        # Get the highest precipitation chance between day and night
        "precip_chance" => day_periods.map { |p| p.dig("probabilityOfPrecipitation", "value") || 0 }.max,
        # Wind usually stays fairly consistent, but we'll take the daytime speed if available
        "wind_speed" => high_period&.dig("windSpeed") || low_period&.dig("windSpeed")
      }
    end
  end

  def format_hourly_forecast(periods)
    periods.each do |period|
      period["windSpeed"] = period["windSpeed"].gsub(" mph", "").to_f
    end
  end
end
