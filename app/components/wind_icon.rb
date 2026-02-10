class Components::WindIcon < Components::Base
  def initialize(wind_direction:, classes: "")
    @wind_direction = wind_direction.downcase
    @classes = classes
  end

  def view_template
    i(class: "wi wi-wind wi-from-#{@wind_direction} #{@classes}")
  end
end
