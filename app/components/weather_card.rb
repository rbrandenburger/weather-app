class Components::WeatherCard < Phlex::HTML
  def initialize(title:)
    @title = title
  end

  def view_template(&)
    div(class: "bg-gray-100 shadow-sm border-b border-red-700 p-5 flex flex-col gap-4") do
      h3(class: "text-xs font-semibold uppercase tracking-widest text-gray-800 border-b pb-2") { @title }
      div(class: "flex flex-col gap-3") do
        yield
      end
    end
  end
end
