module ApplicationHelper
  def completed_count(model)
    count = model.completed_count
    color_class = count > 0 ? "bg-green-500" : "bg-red-500"
    content_tag(:span, "#{count}", class: "#{color_class} ml-2 p-1 rounded-full w-10 h-10 text-center flex items-center justify-center")
  end
end
