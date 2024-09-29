RSpec.describe StationReading do
  let(:klass) { StationReading }

  it "inherits from ApplicationRecord" do
    expect(klass).to be < ApplicationRecord
  end

  describe "#fahrenheit_temp" do
    let(:subject) { object.fahrenheit_temp }
    let(:object) do
      klass.new(
        celcius_temp: celcius_temp,
        relative_humidity: 10,
        recorded_on: Time.current
      )
    end

    let(:celcius_temp) { 35 }

    it "returns the converted temperature" do
      expect(subject).to eq(95)
    end
  end

  describe "fahrenheit_temp=(temp_f)" do
    let(:subject) { object.fahrenheit_temp = temp_f }
    let(:object) do
      klass.new(
        celcius_temp: 0,
        relative_humidity: 10,
        recorded_on: Time.current
      )
    end

    let(:temp_f) { 95 }

    it "updates the celcius_temp" do
      expect { subject }.to change { object.celcius_temp }.from(0).to(35)
    end
  end
end
