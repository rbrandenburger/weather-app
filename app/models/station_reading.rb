class StationReading < ApplicationRecord
  validates :celcius_temp, numericality: true, presence: true
  validates :relative_humidity, numericality: true, presence: true
  validates :recorded_on, presence: true

  def fahrenheit_temp
    (celcius_temp * 1.8) + 32
  end

  def fahrenheit_temp=(temp_f)
    self.celcius_temp = (temp_f - 32) / 1.8
  end
end
