class Components::NavLink < Components::Base
  COMMON_CLASSES = "px-6 py-2 text-sm font-semibold uppercase tracking-wide transition-all flex items-center justify-center min-w-[110px]"

  def initialize(path:, label:)
    @path = path
    @label = label
  end

  def view_template
    if helpers.current_page?(@path)
      span(class: "#{COMMON_CLASSES} bg-white text-red-700 shadow-sm") do
        @label
      end
    else
      a(href: @path, class: "#{COMMON_CLASSES} text-red-100 hover:bg-red-600 hover:text-white") do
        @label
      end
    end
  end
end
