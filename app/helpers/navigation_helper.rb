# app/helpers/navigation_helper.rb
module NavigationHelper
  def nav_link_to(name, path, icon_path = nil)
    active = current_page?(path)
    active_class = active ? "bg-blue-50 text-blue-600" : "text-gray-700 hover:bg-gray-100"
    
    link_to path, class: "px-3 py-2 rounded-md text-sm font-medium transition #{active_class}" do
      content_tag(:div, class: "flex items-center gap-2") do
        concat(nav_icon(icon_path)) if icon_path
        concat(content_tag(:span, name))
      end
    end
  end
  
  def logo_link
    link_to root_path, class: "flex items-center gap-2" do
      concat(logo_icon)
      concat(content_tag(:span, "Oplata Site", class: "font-bold text-xl text-gray-800"))
    end
  end
  
  private
  
  def nav_icon(icon_type)
    case icon_type
    when :payments
      svg_icon("w-4 h-4", "M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z")
    when :dashboard
      svg_icon("w-4 h-4", "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z")
    when :pdf
      svg_icon("w-4 h-4", "M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z M15 13.5a3 3 0 11-6 0 3 3 0 016 0z")
    end
  end
  
  def logo_icon
    svg_icon("w-8 h-8 text-blue-600", "M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z")
  end
  
  def svg_icon(css_class, path)
    tag.svg class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24" do
      tag.path "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: path
    end
  end
end