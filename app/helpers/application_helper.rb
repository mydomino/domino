module ApplicationHelper

  def sortable(column, title = nil, filter: "mine")
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction, :filter => filter}, {:class => "#{css_class} text-decoration-none"}
  end

  def class_for flash_type
    { success: "bg-blue white", error: "bg-red white", alert: "bg-red white", notice: "bg-blue white" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash_html = ''
    flash.each do |msg_type, message|
      flash_html << content_tag(:div, message, class: "p2 border #{class_for(msg_type)} rounded my1 flash-msg-box", role: 'alert') do
        concat message.html_safe
      end
    end
    flash_html.html_safe
  end
  
end