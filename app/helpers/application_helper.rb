module ApplicationHelper
  def class_for flash_type
    { success: "bg-blue white", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash_html = ''
    flash.each do |msg_type, message|
      flash_html << content_tag(:div, message, class: "p2 border #{class_for(msg_type)} rounded", role: 'alert') do
        concat message.html_safe
      end
    end
    flash_html.html_safe
  end
end