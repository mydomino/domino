module ClonesHelper
  def current_clone
    return if request.subdomain.empty?
    match = /(\w+)/.match(request.subdomain)
    clone = match.captures[0] if match
    clone if Clone.all.map(&:name).include?(clone)
  end

end