class Views::Dashboard < Views::Base
  def view_template(&)
    h1(class: "text-2xl") { "hello world" }
  end
end
