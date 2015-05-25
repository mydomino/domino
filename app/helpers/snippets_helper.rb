module SnippetsHelper
  def nested_snippets(snippets)
    snippets.map do |snippet, sub_snippets|
      render(snippet) + content_tag(:div, nested_snippets(sub_snippets),
                                    class: 'nested_snippets')
    end.join.html_safe
  end

  def snippet(key)
    all_keys = Snippet.where(key: key)
    s = all_keys.find {|s| s.clone.name == current_clone if s.clone}
    s ||= all_keys.find {|s| s.clone == nil}
    s ? s.content.html_safe : ""
  end

end