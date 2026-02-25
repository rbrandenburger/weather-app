RSpec.describe Api::BaseUtility do
  let(:klass) { Api::SunriseSunsetUtility }

  around do |example|
    travel_to Time.parse("2026-01-01T00:00:00 -0600") do
      VCR.use_cassette("sunsrise_sunset_utility_tests/success") do
        example.run
      end
    end
  end

  describe ".get_sunrise_sunset" do
    let(:subject) { klass.get_sunrise_sunset }

    it "returns the api response for the current day" do
      expect(subject).to eq({
        "sunrise" => Time.parse("2026-01-01 13:04:45 UTC"),
        "sunset" => Time.parse("2026-01-01 00:14:38 UTC"),
        "solar_noon" => Time.parse("2026-01-01 18:39:42 UTC"),
        "day_length" => "11:09:53",
        "civil_twilight_begin" => Time.parse("2026-01-01 12:38:34 UTC"),
        "civil_twilight_end" => Time.parse("2026-01-01 00:40:49 UTC"),
        "nautical_twilight_begin" => Time.parse("2026-01-01 12:06:46 UTC"),
        "nautical_twilight_end" => Time.parse("2026-01-01 01:12:37 UTC"),
        "astronomical_twilight_begin" => Time.parse("2026-01-01 11:35:03 UTC"),
        "astronomical_twilight_end" => Time.parse("2026-01-01 01:44:20 UTC")
      })
    end

    describe "when the request fails" do
      it "raises an error" do
        allow_any_instance_of(Faraday::Response).to receive(:success?).and_return(false)

        expect { subject }.to raise_error(Api::UtilityError, "failed API request at /json")
      end
    end
  end
end
