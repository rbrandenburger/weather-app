class Components::MobileMenu < Components::Base
  def initialize
  end

  def view_template
    div(class: "md:hidden fixed bottom-6 right-6 z-40") do
      button(
        class: "flex items-center justify-center w-14 h-14 bg-red-700 text-white shadow-2xl rounded-full border border-red-600 active:bg-red-800 transition-colors",
        data_action: "click->navigation#open"
      ) do
        # SVG Hamburger Icon
        svg(
          class: "w-6 h-6",
          fill: "none",
          stroke: "currentColor",
          viewBox: "0 0 24 24",
          xmlns: "http://www.w3.org/2000/svg"
        ) do |s|
          s.path(
            stroke_linecap: "round",
            stroke_linejoin: "round",
            stroke_width: "2",
            d: "M4 6h16M4 12h16M4 18h16"
          )
        end
      end
    end
    # Mobile Bottom Sheet Infrastructure
    div(
      class: "fixed inset-0 bg-black/60 z-50 hidden opacity-0 transition-opacity duration-300",
      data_navigation_target: "backdrop",
      data_action: "click->navigation#close"
    )

    div(
      class: "fixed inset-x-0 bottom-0 z-[60] bg-red-700 p-6 transform translate-y-full transition-transform duration-300 hidden",
      data_navigation_target: "sheet"
    ) do
      # --- The 'X' Close Button ---
      # Positioning it at -top-16 pushes it above the red sheet container
      button(
        class: "absolute -top-16 right-6 flex items-center justify-center w-12 h-12 bg-white text-red-700 shadow-xl rounded-full active:scale-90 transition-transform",
        data_action: "click->navigation#close"
      ) do
        # SVG X (Close) Icon
        svg(
          class: "w-6 h-6",
          fill: "none",
          stroke: "currentColor",
          viewBox: "0 0 24 24",
          xmlns: "http://www.w3.org/2000/svg"
        ) do |s|
          s.path(
            stroke_linecap: "round",
            stroke_linejoin: "round",
            stroke_width: "2",
            d: "M6 18L18 6M6 6l12 12"
          )
        end
      end
      div(class: "flex flex-col space-y-2") do
        Components::NavLink(path: "/", label: "Live")
        Components::NavLink(path: "/history", label: "Historical")
      end
    end
  end
end
