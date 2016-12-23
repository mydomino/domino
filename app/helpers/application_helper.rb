module ApplicationHelper

  # canonical url for posts, used for open graph
  def canonical_url
    if controller_name == "posts" && action_name == "get_post_by_slug"
      request.original_url
    else
      "https://www.mydomino.com"
    end
  end
  
  #helper method for scoping page specific JS
  def page_id
    if id = content_for(:body_id) and id.present?
      return id
    else
      #onboarding form js
      if controller.class.to_s == 'Profile::StepsController'
        base = controller.class.to_s.gsub("Controller", '').underscore.gsub("/", '_')
        return "#{base}-#{step}"
      else
        base = controller.class.to_s.gsub("Controller", '').underscore.gsub("/", '_')
        return "#{base}-#{controller.action_name}"
      end
    end
  end
  
  def page_class
    controller.class.to_s.gsub("Controller", '').underscore.gsub("/", '_') + " " + content_for(:page_class)
  end

  def sortable(column, title = nil, filter: "mine")
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction} " : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction, :filter => filter}, {:class => "#{css_class} text-decoration-none black"}
  end

  def class_for flash_type
    { success: "bg-blue white", error: "bg-red white", alert: "bg-red white", notice: "bg-blue white" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash_html = ''
    flash.each do |msg_type, message|
      flash_html << content_tag(:div, message, class: "p2 border #{class_for(msg_type)} rounded my1", role: 'alert') do
        concat message.html_safe
      end
    end
    flash_html.html_safe
  end

  def onboard_flash
    flash_html = ''
    flash_html << content_tag(:div, flash[:notice], class: 'bg-blue white my3 py2') do
      concat flash[:notice].html_safe
    end
    flash_html.html_safe
  end

  def us_states
    [
      ['AK', 'AK'],
      ['AL', 'AL'],
      ['AR', 'AR'],
      ['AZ', 'AZ'],
      ['CA', 'CA'],
      ['CO', 'CO'],
      ['CT', 'CT'],
      ['DC', 'DC'],
      ['DE', 'DE'],
      ['FL', 'FL'],
      ['GA', 'GA'],
      ['HI', 'HI'],
      ['IA', 'IA'],
      ['ID', 'ID'],
      ['IL', 'IL'],
      ['IN', 'IN'],
      ['KS', 'KS'],
      ['KY', 'KY'],
      ['LA', 'LA'],
      ['MA', 'MA'],
      ['MD', 'MD'],
      ['ME', 'ME'],
      ['MI', 'MI'],
      ['MN', 'MN'],
      ['MO', 'MO'],
      ['MS', 'MS'],
      ['MT', 'MT'],
      ['NC', 'NC'],
      ['ND', 'ND'],
      ['NE', 'NE'],
      ['NH', 'NH'],
      ['NJ', 'NJ'],
      ['NM', 'NM'],
      ['NV', 'NV'],
      ['NY', 'NY'],
      ['OH', 'OH'],
      ['OK', 'OK'],
      ['OR', 'OR'],
      ['PA', 'PA'],
      ['RI', 'RI'],
      ['SC', 'SC'],
      ['SD', 'SD'],
      ['TN', 'TN'],
      ['TX', 'TX'],
      ['UT', 'UT'],
      ['VA', 'VA'],
      ['VT', 'VT'],
      ['WA', 'WA'],
      ['WI', 'WI'],
      ['WV', 'WV'],
      ['WY', 'WY']
    ]
  end
  
end