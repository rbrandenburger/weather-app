class StationReading < ApplicationRecord
  def fahrenheit_temp
    (celcius_temp * 1.8) + 32
  end

  def fahrenheit_temp=(temp_f)
    self.celcius_temp = (temp_f - 32) / 1.8
  end
end
