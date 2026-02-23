# frozen_string_literal: true

class Components::Header < Components::Base
  def view_template
    header(class: "w-full bg-red-700 text-white shadow-md") do
      nav(class: "container mx-auto px-5 py-4 flex items-center justify-between") do
        a(href: root_path, class: "text-xl font-medium tracking-tight hover:text-red-100 transition-colors") do
          "Remington's Weather Station"
        end
      end
    end
  end
end
