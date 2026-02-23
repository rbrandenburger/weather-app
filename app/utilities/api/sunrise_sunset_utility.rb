class Api::SunriseSunsetUtility < Api::BaseUtility
  class << self
    def get_sunrise_sunset
      response_payload = get_request("/json", {lat: 40.806862, lng: -96.681679})

      tz = response_payload["tzid"]

      response_payload["results"].transform_values! do |time_string|
        Time.strptime("#{time_string} #{tz}", "%r %Z")
      rescue ArgumentError
        time_string
      end

      response_payload["results"]
    end

    private

    def client_url
      "https://api.sunrise-sunset.org/"
    end
  end
end
