class StationReading < ApplicationRecord
  validates :celsius_temp, numericality: true, presence: true
  validates :relative_humidity, numericality: true, presence: true
  validates :recorded_on, presence: true

  def fahrenheit_temp
    return @fahrenheit_temp if defined?(@fahrenheit_temp)

    @fahrenheit_temp = celsius_to_fahrenheit(celsius_temp)
  end

  # TODO: Why?
  def fahrenheit_temp=(temp_f)
    self.celsius_temp = fahrenheit_to_celsius(temp_f)
  end

  def dew_point(celsius: true)
    # Magnus coeffecients
    a = 17.625
    b = 243.04

    rh_factor = Math.log(relative_humidity / 100) + (a * celsius_temp) / (b + celsius_temp)

    dew_point = (b * rh_factor) / (a - rh_factor)

    celsius ? dew_point : celsius_to_fahrenheit(dew_point)
  end

  def feels_like(wind_speed, celsius: true)
    # NWS reports wind chill when temp is lower than 50F, and wind speed is greater than 3mph.
    # Heat index is reported when temp is over 80F

    if fahrenheit_temp <= 50.0 && wind_speed > 3
      wind_chill(wind_speed, celsius: celsius)
    elsif fahrenheit_temp > 80.0
      heat_index(celsius: celsius)
    else
      celsius ? celsius_temp : fahrenheit_temp
    end
  end

  def heat_index(celsius: true)
    # Following Rothfusz formula from NOAA

    hi = 0.5 * (fahrenheit_temp + 61.0 + ((fahrenheit_temp - 68.0) * 1.2) + (relative_humidity * 0.094))
    hi = (hi + fahrenheit_temp) / 2.0

    return hi if hi <= 80.0

    # A more complex formula is needed when heat index is greater than 80.0
    hi = -42.379 + (2.04901523 * fahrenheit_temp) + (10.14333127 * relative_humidity) -
      (0.22475541 * fahrenheit_temp * relative_humidity) - (0.00683783 * fahrenheit_temp * fahrenheit_temp) -
      (0.05481717 * relative_humidity * relative_humidity) + (0.00122874 * fahrenheit_temp * fahrenheit_temp * relative_humidity) +
      (0.00085282 * fahrenheit_temp * relative_humidity * relative_humidity) - (0.00000199 * fahrenheit_temp * fahrenheit_temp * relative_humidity * relative_humidity)

    # adjustments
    if relative_humidity < 13.0 && fahrenheit_temp > 80.0 && fahrenheit_temp < 112.0
      hi -= ((13.0 - relative_humidity) / 4.0) * Math.sqrt((17.0 - (fahrenheit_temp - 95.0).abs) / 17.0)
    elsif relative_humidity > 85.0 && fahrenheit_temp > 80.0 && fahrenheit_temp < 87.0
      hi += ((relative_humidity - 85.0) / 10) * (87 - fahrenheit_temp / 5)
    end

    celsius ? fahrenheit_to_celsius(hi) : hi
  end

  def wind_chill(wind_speed, celsius: true)
    # Formula copied from the NWS
    # Wind speed must be in mph

    ws = 35.74 + (0.6215 * fahrenheit_temp) - (35.75 * (wind_speed**0.16)) + (0.4275 * fahrenheit_temp * (wind_speed**0.16))

    celsius ? fahrenheit_to_celsius(ws) : ws
  end

  private

  def celsius_to_fahrenheit(c)
    (c * 1.8) + 32
  end

  def fahrenheit_to_celsius(f)
    (f - 32) / 1.8
  end
end
