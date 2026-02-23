RSpec.describe StationReading do
  let(:klass) { StationReading }

  it "inherits from ApplicationRecord" do
    expect(klass).to be < ApplicationRecord
  end

  describe "#fahrenheit_temp" do
    let(:subject) { station_reading.fahrenheit_temp }
    let(:station_reading) { Fabricate(:station_reading, celsius_temp: 35) }

    it "returns the converted temperature" do
      expect(subject).to eq(95)
    end
  end

  describe "#fahrenheit_temp=(temp_f)" do
    let(:subject) { station_reading.fahrenheit_temp = temp_f }
    let(:station_reading) { Fabricate(:station_reading, celsius_temp: 0) }

    let(:temp_f) { 95 }

    it "updates the celsius_temp" do
      expect { subject }.to change { station_reading.celsius_temp }.from(0).to(35)
    end
  end

  describe "#dew_point(celsius: true)" do
    let(:subject) { station_reading.dew_point(celsius: celsius) }
    let(:station_reading) { Fabricate(:station_reading, celsius_temp: 24, relative_humidity: 44) }

    describe "when requesting the dew point in celsius" do
      let(:celsius) { true }

      it "returns the dew point in C" do
        expect(subject).to be_within(0.01).of(11.0)
      end
    end

    describe "when requesting the dew point in fahrenheit" do
      let(:celsius) { false }

      it "returns the dew point in F" do
        expect(subject).to be_within(0.01).of(51.8)
      end
    end
  end

  describe "#heat_index(celsius: true)" do
    # Test values used from NWS heat index chart
    let(:subject) { station_reading.heat_index(celsius: celsius) }
    let(:station_reading) { Fabricate(:station_reading, celsius_temp: celsius_temp, relative_humidity: relative_humidity) }
    let(:celsius_temp) { 30 }
    let(:relative_humidity) { 85 }

    describe "when requesting the head index in celsius" do
      let(:celsius) { true }

      it "returns the heat index in C" do
        expect(subject).to be_within(0.1).of(39.1)
      end
    end

    describe "when requesting the head index in fahrenheit" do
      let(:celsius) { false }

      it "returns the heat index in F" do
        expect(subject).to be_within(0.1).of(102.4)
      end
    end

    describe "edge cases" do
      let(:celsius) { false }

      describe "when rh < 13 and temp is between 80F and 112F" do
        let(:celsius_temp) { 40 }
        let(:relative_humidity) { 12 }
        let(:celsius) { false }

        it "returns the correct value" do
          expect(subject).to be_within(0.1).of(99.1)
        end
      end

      describe "when rh > 85 and temp is between 80F and 87F" do
        let(:celsius_temp) { 27 }
        let(:relative_humidity) { 86 }

        it "returns the correct value" do
          expect(subject).to be_within(0.1).of(86.7)
        end
      end
    end
  end

  describe "#wind_chill(wind_speed, celsius: true)" do
    let(:subject) { station_reading.wind_chill(wind_speed, celsius: celsius) }
    let(:station_reading) { Fabricate(:station_reading, celsius_temp: 0) }
    let(:wind_speed) { 20 }

    describe "when requesting the wind chill in C" do
      let(:celsius) { true }

      it "returns the wind chill in C" do
        expect(subject).to be_within(0.1).of(-6.6)
      end
    end

    describe "when requesting the wind chill in F" do
      let(:celsius) { false }

      it "returns the wind chill in F" do
        expect(subject).to be_within(0.1).of(20.0)
      end
    end

    describe "when there is calm wind" do
      let(:celsius) { true }
      let(:wind_speed) { 2.9 }

      it "returns the current temperature" do
        expect(subject).to eq(station_reading.celsius_temp)
      end
    end
  end

  describe "#feels_like(wind_speed, celsius: true)" do
    let(:subject) { station_reading.feels_like(wind_speed) }
    let(:station_reading) do
      Fabricate(
        :station_reading,
        celsius_temp: celsius_temp,
        relative_humidity: relative_humidity
      )
    end

    let(:wind_speed) { 10 }
    let(:relative_humidity) { 60 }

    describe "when temp is less than 10C and wind speed is at least 3mph" do
      let(:celsius_temp) { 9.9 }

      it "returns the wind chill" do
        expect(subject).to eq(station_reading.wind_chill(wind_speed))
      end
    end

    describe "when temp is greater than 26.6C" do
      let(:celsius_temp) { 26.7 }

      it "returns the wind chill" do
        expect(subject).to eq(station_reading.heat_index)
      end
    end

    describe "when the temp is between 10 and 26.6C" do
      let(:station_reading) { Fabricate(:station_reading) }

      [10.1, 26.5].each do |temp_c|
        it "returns the current temperature" do
          allow(station_reading).to receive(:celsius_temp).and_return(temp_c)
          expect(subject).to eq(temp_c)
        end
      end
    end
  end
end
