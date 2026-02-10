class StationReading < ApplicationRecord
  validates :celcius_temp, numericality: true, presence: true
  validates :relative_humidity, numericality: true, presence: true
  validates :recorded_on, presence: true

  def fahrenheit_temp
    celsius_to_fahrenheit(celcius_temp)
  end

  # TODO: Why?
  def fahrenheit_temp=(temp_f)
    self.celcius_temp = (temp_f - 32) / 1.8
  end

  def dew_point(celsius: true)
    # Magnus coeffecients
    a = 17.625
    b = 243.04

    rh_factor = Math.log(relative_humidity / 100) + (a * celcius_temp) / (b + celcius_temp)

    dew_point = (b * rh_factor) / (a - rh_factor)

    celsius ? dew_point : celsius_to_fahrenheit(dew_point)
  end

  private

  def celsius_to_fahrenheit(c)
    (c * 1.8) + 32
  end
end
