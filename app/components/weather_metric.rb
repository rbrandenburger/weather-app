class Components::WeatherMetric < Components::Base
  def initialize(label:, value:, unit: nil)
    @label = label
    @value = value
    @unit = unit
  end

  def view_template
    div(class: "flex justify-between items-baseline") do
      span(class: "flex self-center text-sm text-gray-600") { @label }

      div(class: "text-lg font-semibold text-gray-900") do
        if @value.is_a?(Phlex::HTML)
          render @value
        else
          plain @value
        end

        if @unit
          span(class: "ml-1 text-xs font-normal text-gray-600 uppercase tracking-tighter") { @unit }
        end
      end
    end
  end
end
