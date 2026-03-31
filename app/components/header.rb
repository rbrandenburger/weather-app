class Components::Header < Components::Base
  def view_template
    # The parent container keeps the Stimulus controller scope
    div(data_controller: "navigation", class: "relative") do
      desktop_header
      render Components::Header::MobileMenu.new
    end
  end

  private

  def desktop_header
    header(class: "w-full bg-red-700 text-white shadow-md") do
      nav(class: "container mx-auto px-5 py-4 flex items-center justify-between") do
        a(href: root_path, class: "text-xl md:text-2xl font-bold tracking-tight") do
          "Remington's Weather Station"
        end

        div(class: "hidden md:flex bg-red-800/50 p-1 rounded-lg") do
          render Components::NavLink.new(path: "/", label: "Live")
          render Components::NavLink.new(path: "/history", label: "Historical")
        end
      end
    end
  end
end
