module ApplicationHelper
  def flash_classes(flash_type)
    flash_base = "px-2 py-4 mx-auto font-sans font-medium text-center text-white"
    {
      notice: "bg-indigo-600 #{flash_base}",
      error:  "bg-red-600 #{flash_base}",
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end
