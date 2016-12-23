module GraphicsHelper
  def embedded_svg filename, options={}
    file = File.read(Rails.root.join('app', 'assets', 'images', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] = options[:class]
    end
    if options[:style].present?
      svg['style'] = options[:style]
    end
    if options[:id].present?
      svg['id'] = options[:id]
    end
    if options[:alt].present?
      svg['alt'] = options[:alt]
    end
    doc.to_html.html_safe
  end
end