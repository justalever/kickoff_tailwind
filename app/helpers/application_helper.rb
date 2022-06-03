module ApplicationHelper
  def flash_classes(flash_type)
    flash_base = "px-2 py-4 mx-auto font-sans font-medium text-center text-white"
    {
      notice: "bg-indigo-600 #{flash_base}",
      error:  "bg-red-600 #{flash_base}",
      alert: "bg-red-600 #{flash_base}"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def nav_classes
    ["devise/registrations", "devise/sessions", "devise/confirmations", "devise/passwords", "devise/unlocks"].include?(params[:controller]) ? "hidden" : nil
  end

  def label_class(options={})
    "block mb-1 font-normal leading-normal #{options[:extended_classes]}"
  end

  def input_class(options={})
    "rounded border border-gray-300 block w-full focus:outline-none focus:border-gray-400 outline-none focus-within:outline-none focus:ring-2 focus:ring-gray-200 #{options[:extended_classes]}"
  end

  def checkbox_class(options={})
    "rounded border-gray-300 border focus:ring-2 focus:ring-gray-200 text-blue-500 mr-1 #{options[:extended_classes]}"
  end

  def link_class(options={})
    "text-gray-700 underline hover:no-underline hover:text-gray-800 block #{options[:extended_classes]}"
  end

  def button_class(options={})
    variant = options[:variant]
    theme = options[:theme]

    style_button(variant, theme_button(theme))
  end

  def theme_button(theme)
    themes = {
      primary: "primary",
      secondary: "secondary",
      transparent: "transparent",
      dark: "dark"
    }

    case theme
    when themes[:primary]
      "bg-indigo-600 hover:bg-indigo-700 text-white"
    when themes[:secondary]
      "bg-teal-600 hover:bg-teal-700 text-white"
    when themes[:transparent]
      "bg-transparent hover:bg-gray-100 text-gray-700"
    when themes[:dark]
      "bg-gray-800 text-white shadow-sm hover:bg-gray-900"
    else
      "bg-white border border-gray-300 shadow-sm hover:bg-gray-100"
    end
  end

  def style_button(variant, theme)
    base = "rounded text-center font-sans font-normal outline-none leading-normal cursor-pointer transition ease-in-out duration-200 font-medium"

    case variant
    when "large"
      "px-5 py-4 text-lg #{base} #{theme}"
    when "small"
      "py-2 px-4 text-sm #{base} #{theme}"
    when "expanded"
      "p-3 w-full block #{base} #{theme}"
    else
      "px-5 py-2 text-base #{base} #{theme}"
    end
  end
end
