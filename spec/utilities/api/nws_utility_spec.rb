RSpec.describe Api::NwsUtility do
  let(:klass) { Api::NwsUtility }

  around do |example|
    VCR.use_cassette("nws_utility_tests/#{cassette}") do
      example.run
    end
  end

  shared_examples "forecast response" do
    it "returns a valid forecast structure" do
      expect(subject.keys).to include("periods")

      expect(subject["periods"]).to be_an(Array)
      expect(subject["periods"]).not_to be_empty

      expect(subject["periods"].first).to include(
        "number" => be_an(Integer),
        "temperature" => be_an(Integer),
        "temperatureUnit" => "F",
        "shortForecast" => be_a(String)
      )
    end
  end

  describe ".get_period_forecast" do
    let(:subject) { klass.get_period_forecast }
    let(:cassette) { "get_period_forecast/success" }

    it_behaves_like "forecast response"

    describe "when the request fails" do
      it "raises an api utility error" do
        allow_any_instance_of(Faraday::Response).to receive(:success?).and_return(false)

        expect { subject }.to raise_error(Api::UtilityError, "failed API request at gridpoints/OAX/56,39/forecast")
      end
    end
  end

  describe ".get_hourly_forecast" do
    let(:subject) { klass.get_hourly_forecast }
    let(:cassette) { "get_hourly_forecast/success" }

    it_behaves_like "forecast response"

    describe "when the request fails" do
      it "raises an api utility error" do
        allow_any_instance_of(Faraday::Response).to receive(:success?).and_return(false)

        expect { subject }.to raise_error(Api::UtilityError, "failed API request at gridpoints/OAX/56,39/forecast/hourly")
      end
    end
  end
end
