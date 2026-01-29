# frozen_string_literal: true

class Components::Header < Components::Base
  def view_template
    header(class: "w-full bg-red-600 text-white shadow-md") do
      nav(class: "container mx-auto px-5 py-4 flex items-center justify-between") do
        a(href: root_path, class: "text-2xl font-bold tracking-tight hover:text-red-100 transition-colors") do
          "Weather App"
        end
      end
    end
  end
end
