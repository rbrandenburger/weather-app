RSpec.describe ReadingsController, type: :request do
  describe "/api/readings" do
    let(:send_request) { post(route, params: params, headers: headers) }
    let(:route) { "/api/readings" }
    let(:headers) { {"x-api-key" => api_key, "content-type" => "application/json"} }
    let(:api_key) { "test_api_key" }
    let(:params) do
      {
        temp_c: temp_c,
        relative_humidity: relative_humidity,
        recorded_on: recorded_on
      }.to_json
    end

    let(:temp_c) { 35 }
    let(:relative_humidity) { 50 }
    let(:recorded_on) { Time.current.iso8601 }

    it "returns a 201 status" do
      send_request

      expect(response.status).to eq(201)
    end

    it "creates a StationReading" do
      expect { send_request }.to change { StationReading.count }.by(1)
    end

    describe "when given invalid params" do
      let(:temp_c) { "foo" }

      it "returns a 400 status" do
        send_request

        expect(response.status).to eq(400)
      end

      it "does not create a reading" do
        expect { send_request }.not_to change { StationReading.count }
      end
    end

    describe "when given an unknown api key" do
      let(:api_key) { "foo" }

      it "returns a 403 status" do
        send_request

        expect(response.status).to eq(403)
      end

      it "does not create a reading" do
        expect { send_request }.not_to change { StationReading.count }
      end
    end
  end

  describe "/" do
    let(:send_request) { get(route, params: {}, headers: {}) }
    let(:route) { "/" }
    let(:low_reading) { Fabricate(:station_reading, celsius_temp: 10, recorded_on: Time.parse("2026-01-01T00:00:00 -0600")) }
    let(:high_reading) { Fabricate(:station_reading, celsius_temp: 30, recorded_on: Time.parse("2026-01-01T10:00:00 -0600")) }
    let(:latest_reading) { Fabricate(:station_reading, celsius_temp: 20, recorded_on: Time.parse("2026-01-01T20:00:00 -0600")) }
    let(:old_reading) { Fabricate(:station_reading, celsius_temp: 0, recorded_on: Time.parse("2025-12-31T23:59:59 -0600")) }

    before do
      low_reading
      high_reading
      latest_reading
      old_reading
    end

    around do |example|
      travel_to Time.parse("2026-01-01T23:59:59 -0600") do
        VCR.use_cassette("readings_controller_tests/success") do
          example.run
        end
      end
    end

    it "returns a 200 status" do
      send_request

      expect(response.status).to eq(200)
    end

    it "renders the dashboard view" do
      expect_any_instance_of(ReadingsController).to receive(:render).with(Views::Dashboard)

      send_request
    end

    it "uses the latest station reading" do
      expect_any_instance_of(ReadingsController).to receive(:render) do |controller, view|
        expect(
          view.instance_variable_get(:@current_weather)["current_temp"]
        ).to eq(latest_reading)
      end

      send_request
    end

    it "includes the highest and lowest daily reading" do
      expect_any_instance_of(ReadingsController).to receive(:render) do |controller, view|
        current_weather = view.instance_variable_get(:@current_weather)

        expect(current_weather["highest_temp"]).to eq(high_reading)
        expect(current_weather["lowest_temp"]).to eq(low_reading)
      end

      send_request
    end

    it "includes forecast details" do
      expect_any_instance_of(ReadingsController).to receive(:render) do |controller, view|
        forecast = view.instance_variable_get(:@forecast)

        expect(forecast.keys).to eq(["periods", "daily", "hourly", "sun_info"])

        expect(forecast["periods"].first).to eq({
          "number" => 1,
          "name" => "This Afternoon",
          "startTime" => "2026-02-25T14:00:00-06:00",
          "endTime" => "2026-02-25T18:00:00-06:00",
          "isDaytime" => true,
          "temperature" => 54,
          "temperatureUnit" => "F",
          "temperatureTrend" => nil,
          "probabilityOfPrecipitation" => {"unitCode" => "wmoUnit:percent", "value" => 27},
          "windSpeed" => "9 mph",
          "windDirection" => "ESE",
          "icon" => "https://api.weather.gov/icons/land/day/rain,30?size=medium",
          "shortForecast" => "Chance Light Rain",
          "detailedForecast" => "A chance of rain after 4pm. Mostly sunny, with a high near 54. East southeast wind around 9 mph. Chance of precipitation is 30%."
        })

        expect(forecast["daily"].first).to eq({
          "date" => "Wednesday",
          "icon" => "https://api.weather.gov/icons/land/day/rain,30?size=medium",
          "high" => 54,
          "low" => 27,
          "precip_chance" => 36,
          "wind_speed" => "9 mph"
        })

        expect(forecast["hourly"].first).to eq({
          "number" => 1,
          "name" => "",
          "startTime" => "2026-02-25T14:00:00-06:00",
          "endTime" => "2026-02-25T15:00:00-06:00",
          "isDaytime" => true,
          "temperature" => 51,
          "temperatureUnit" => "F",
          "temperatureTrend" => nil,
          "probabilityOfPrecipitation" => {"unitCode" => "wmoUnit:percent", "value" => 1},
          "dewpoint" => {"unitCode" => "wmoUnit:degC", "value" => 0},
          "relativeHumidity" => {"unitCode" => "wmoUnit:percent", "value" => 48},
          "windSpeed" => 8.0,
          "windDirection" => "SE",
          "icon" => "https://api.weather.gov/icons/land/day/sct?size=small",
          "shortForecast" => "Mostly Sunny",
          "detailedForecast" => ""
        })

        expect(forecast["sun_info"]).to eq({
          "sunrise" => Time.parse("2026-01-02 13:04:45 UTC"),
          "sunset" => Time.parse("2026-01-02 00:14:38 UTC"),
          "solar_noon" => Time.parse("2026-01-02 18:39:42 UTC"),
          "day_length" => "11:09:53",
          "civil_twilight_begin" => Time.parse("2026-01-02 12:38:34 UTC"),
          "civil_twilight_end" => Time.parse("2026-01-02 00:40:49 UTC"),
          "nautical_twilight_begin" => Time.parse("2026-01-02 12:06:46 UTC"),
          "nautical_twilight_end" => Time.parse("2026-01-02 01:12:37 UTC"),
          "astronomical_twilight_begin" => Time.parse("2026-01-02 11:35:03 UTC"),
          "astronomical_twilight_end" => Time.parse("2026-01-02 01:44:20 UTC")
        })
      end

      send_request
    end
  end
end
