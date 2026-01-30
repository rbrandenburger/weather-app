class Api::NwsUtility < Api::BaseUtility
  class << self
    def get_period_forecast
      response_payload = get_request("gridpoints/OAX/56,39/forecast")

      response_payload["properties"]
    end

    def get_hourly_forecast
      response_payload = get_request("gridpoints/OAX/56,39/forecast/hourly")

      response_payload["properties"]
    end

    private

    def client_url
      "https://api.weather.gov/"
    end
  end
end
