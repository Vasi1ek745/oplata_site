# app/helpers/notifications_helper.rb
module NotificationsHelper
  def render_notifications
    safe_join([
      render_notice_if_present,
      render_alert_if_present
    ].compact)
  end
  
  private
  
  def render_notice_if_present
    return unless notice.present?
    
    content_tag :div, 
                class: "toast toast-success animate-slide-in-right", 
                data: { controller: "notification" } do
      concat notification_icon(:success)
      concat content_tag(:div, notice, class: "toast-content")
      concat notification_close_button
    end
  end
  
  def render_alert_if_present
    return unless alert.present?
    
    content_tag :div, 
                class: "toast toast-error animate-slide-in-right", 
                data: { controller: "notification" } do
      concat notification_icon(:error)
      concat content_tag(:div, alert, class: "toast-content")
      concat notification_close_button
    end
  end
  
  def notification_icon(type)
    icon_path = type == :success ? 
      "M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" : 
      "M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
    
    icon_color = type == :success ? "text-green-600" : "text-red-600"
    
    content_tag :div, class: "toast-icon" do
      tag.svg class: "w-5 h-5 #{icon_color}", 
              fill: "none", 
              stroke: "currentColor", 
              viewBox: "0 0 24 24" do
        tag.path "stroke-linecap": "round", 
                 "stroke-linejoin": "round", 
                 "stroke-width": "2", 
                 d: icon_path
      end
    end
  end
  
  def notification_close_button
    content_tag :button, 
                class: "toast-close", 
                onclick: "this.closest('[data-controller=\"notification\"]').remove()" do
      tag.svg class: "w-4 h-4", 
              fill: "none", 
              stroke: "currentColor", 
              viewBox: "0 0 24 24" do
        tag.path "stroke-linecap": "round", 
                 "stroke-linejoin": "round", 
                 "stroke-width": "2", 
                 d: "M6 18L18 6M6 6l12 12"
      end
    end
  end
end