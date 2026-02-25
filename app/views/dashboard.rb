class Views::Dashboard < Views::Base
  def initialize(current_weather:, forecast:)
    @current_weather = current_weather
    @forecast = forecast
  end

  def view_template
    div(class: "p-8 max-w-5xl mx-auto text-slate-800") do
      # Current conditions
      div(class: "flex items-center justify-between gap-4 mb-8") do
        div(class: "flex gap-4") do
          div do
            h1(class: "text-4xl font-bold") { "Lincoln, NE" }
            p(class: "text-slate-500") { Time.now.strftime("%A, %B %d") }
          end
        end

        div(class: "text-left flex gap-4 items-center") do
          current_hour = @forecast["hourly"].first
          render Components::WeatherIcon.new(
            icon_url: current_hour["icon"],
            is_daytime: current_hour["isDaytime"],
            classes: "text-5xl"
          )
        end
      end

      div(class: "grid grid-cols-1 md:grid-cols-3 gap-6 py-6") do
        # Card 1: Temperature & Extremes
        render Components::WeatherCard.new(title: "Temperature") do
          render Components::WeatherMetric.new(label: "Currently", value: @current_weather["current_temp"].fahrenheit_temp.round, unit: "°F")
          render Components::WeatherMetric.new(label: "Feels Like", value: @current_weather["current_temp"].feels_like(@forecast["hourly"].first["windSpeed"], celsius: false).round, unit: "°F")
          render Components::WeatherMetric.new(label: "Highest Reading Today", value: @current_weather["highest_temp"]&.fahrenheit_temp&.round, unit: "°F")
          render Components::WeatherMetric.new(label: "Lowest Reading Today", value: @current_weather["lowest_temp"]&.fahrenheit_temp&.round, unit: "°F")
        end

        # Card 2: Conditions & Air
        render Components::WeatherCard.new(title: "Atmospherics") do
          render Components::WeatherMetric.new(label: "Wind Speed", value: @forecast["hourly"].first["windSpeed"], unit: "mph")
          render Components::WeatherMetric.new(label: "Wind Direction", value: Components::WindIcon.new(wind_direction: @forecast["hourly"].first["windDirection"], classes: "text-3xl"))
          render Components::WeatherMetric.new(label: "Humidity", value: @current_weather["current_temp"].relative_humidity.round.to_s, unit: "%")
          render Components::WeatherMetric.new(label: "Dew Point", value: @current_weather["current_temp"].dew_point(celsius: false).round.to_s, unit: "°F")
        end

        # Card 3: Daylight
        render Components::WeatherCard.new(title: "Daylight") do
          render Components::WeatherMetric.new(label: "Sunrise", value: @forecast["sun_info"]["sunrise"].in_time_zone("America/Chicago").strftime("%l:%M"), unit: "am cst")
          render Components::WeatherMetric.new(label: "Sunset", value: @forecast["sun_info"]["sunset"].in_time_zone("America/Chicago").strftime("%l:%M"), unit: "pm cst")

          # Custom Row for Day Length
          div(class: "flex justify-between items-baseline") do
            span(class: "text-sm text-gray-600") { "Day Length" }

            div(class: "text-lg font-bold text-gray-900 flex items-baseline justify-end") do
              h, m, _ = @forecast["sun_info"]["day_length"].split(":")

              plain h.to_i
              span(class: "text-xs font-normal text-gray-600 ml-0.5 mr-1") { "h" }
              plain m.to_i
              span(class: "text-xs font-normal text-gray-600 ml-0.5") { "m" }
            end
          end
        end
      end

      hr(class: "border-gray-400 py-2")
      # Hourly Forecast

      h1(class: "text-2xl pb-2") { "Hourly Forecast" }

      div(class: "flex gap-2 overflow-x-auto snap-x pb-4 w-full") do
        @forecast["hourly"].take(24).each do |hour|
          div(class: "flex-none w-20 flex flex-col items-center gap-1 snap-center p-2 bg-gray-100 shadow-sm border-b border-red-700") do
            p(class: "text-[10px] uppercase font-bold text-gray-400") do
              Time.parse(hour["startTime"]).in_time_zone("America/Chicago").strftime("%-l %P")
            end

            render Components::WeatherIcon.new(icon_url: hour["icon"], is_daytime: hour["isDaytime"], classes: "text-3xl my-1")

            p(class: "text-lg font-semibold") { "#{hour["temperature"].round}°F" }

            # Small rain chance indicator
            div(class: "flex items-center gap-0.5 text-blue-500") do
              i(class: "wi wi-raindrop text-[10px]")
              span(class: "text-[10px] font-bold") { "#{hour["probabilityOfPrecipitation"]["value"]}%" }
            end

            div(class: "flex items-center gap-1 text-gray-500") do
              i(class: "wi wi-strong-wind text-xs") {}
              span(class: "text-[10px] font-semibold") { hour["windSpeed"] }
            end
          end
        end
      end
      hr(class: "border-gray-400 py-2")
      # Daily Forecast

      h1(class: "text-2xl pb-2") { "Daily Forecast" }

      div(class: "flex gap-4 overflow-x-auto snap-x pb-4 w-full") do
        @forecast["daily"].each do |day|
          forecast_card(day)
        end
      end
    end
  end

  private

  def forecast_card(day)
    div(class: "px-2 py-5 bg-gray-100 border-b border-red-700 flex flex-col items-center gap-2 min-w-[120px]") do
      # Date Header
      p(class: "text-sm font-bold uppercase tracking-wider text-gray-500") { day["date"] }

      render Components::WeatherIcon.new(icon_url: day["icon"], is_daytime: true, classes: "text-3xl my-1")

      # Temperature Group
      div(class: "flex items-baseline gap-1") do
        span(class: "text-xl font-bold text-gray-800") { "#{day["high"]}°F" }
        span(class: "text-sm font-medium text-gray-400") { "#{day["low"]}°F" }
      end

      # Metadata Row (Wind & Precip)
      div(class: "flex flex-col gap-3 mt-2 pt-3 border-t border-gray-300 w-full justify-center") do
        div(class: "flex items-center justify-center gap-1 text-blue-400") do
          i(class: "wi wi-raindrop text-sm") {}
          span(class: "text-sm font-semibold") { "#{day["precip_chance"]}%" }
        end
        div(class: "flex items-center justify-center gap-1 text-gray-500") do
          i(class: "wi wi-strong-wind text-xs") {}
          span(class: "text-[12px] font-semibold") { day["wind_speed"] }
        end
      end
    end
  end
end
