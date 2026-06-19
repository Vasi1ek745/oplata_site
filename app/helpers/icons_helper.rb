# app/helpers/icons_helper.rb
module IconsHelper
  def refresh_icon(css_class = "w-5 h-5")
    tag.svg class: "#{css_class} refresh-icon", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24" do
      tag.path "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2",
               d: "M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
    end
  end
  
  def spinner_icon(css_class = "w-5 h-5")
    tag.svg class: "#{css_class} animate-spin", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24" do
      tag.path "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2",
               d: "M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
    end
  end
  
  def empty_state_icon(css_class = "mx-auto h-10 w-10 text-gray-400")
    tag.svg class: css_class, fill: "none", stroke: "currentColor", viewBox: "0 0 24 24" do
      tag.path "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2",
               d: "M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
    end
  end
end