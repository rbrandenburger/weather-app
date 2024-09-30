RSpec.describe ReadingsController, type: :request do
  let(:send_request) { post(route, params: params, headers: headers) }

  describe "/readings/create" do
    let(:route) { "/readings/create" }
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

    describe "when given bad params" do
      let(:temp_c) { "foo" }

      it "returns a 401 status" do
        send_request

        expect(response.status).to eq(401)
      end
    end

    describe "when given an unknown api key" do
      let(:api_key) { "foo" }

      it "returns a 403 status" do
        send_request

        expect(response.status).to eq(403)
      end
    end
  end
end
