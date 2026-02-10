class Components::WeatherIcon < Components::Base
  ICON_MAPPING = {
    "skc" => {day: "wi-day-sunny", night: "wi-night-clear"},
    "few" => {day: "wi-day-cloudy-high", night: "wi-night-alt-cloudy"},
    "sct" => {day: "wi-day-cloudy", night: "wi-night-alt-cloudy"},
    "bkn" => {day: "wi-day-cloudy", night: "wi-night-alt-cloudy"},
    "ovc" => {day: "wi-cloudy", night: "wi-cloudy"},
    "wind" => {day: "wi-strong-wind", night: "wi-strong-wind"},
    "snow" => {day: "wi-snow", night: "wi-snow"},
    "rain" => {day: "wi-rain", night: "wi-rain"},
    "tsra" => {day: "wi-thunderstorm", night: "wi-thunderstorm"},
    "tsra_sct" => {day: "wi-day-thunderstorm", night: "wi-night-alt-thunderstorm"},
    "tsra_hi" => {day: "wi-day-thunderstorm", night: "wi-night-alt-thunderstorm"},
    "tornado" => {day: "wi-tornado", night: "wi-tornado"},
    "fog" => {day: "wi-fog", night: "wi-fog"},
    "cold" => {day: "wi-day-sunny", night: "wi-night-clear"},
    "hot" => {day: "wi-hot", night: "wi-hot"},
    "blizzard" => {day: "wi-snow-wind", night: "wi-snow-wind"},
    "unknown" => {day: "wi-na", night: "wi-na"}
  }

  def initialize(icon_url:, is_daytime:, classes: "")
    @icon_url = icon_url
    @is_daytime = is_daytime
    @classes = classes
  end

  def view_template
    i(class: "wi #{icon_code} #{@classes}")
  end

  private

  def icon_code
    match = @icon_url&.match(/\/(?:day|night)\/([a-z_]+)/)
    code = match ? match[1] : "unknown"
    pp @icon_url
    pp code
    mapping = ICON_MAPPING[code]

    @is_daytime ? mapping[:day] : mapping[:night]
  end
end
