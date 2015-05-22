module ClonesHelper
  def current_clone
    request.subdomain if Clone.all.map(&:name).include? request.subdomain
  end

end