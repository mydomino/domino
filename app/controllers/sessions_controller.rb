class SessionsController < Devise::SessionsController
  def new
    # Store path of referer in session var
    # For redirection back to article views
    (session[:referer] = URI(request.referer).path) if request.referer
    super
  end

  def create
    super
    @tracker.track(current_user.id, "User logged in");
    @tracker.people.set(current_user.id,{     
      '$last_login_ip' => current_user.current_sign_in_ip.to_s},current_user.current_sign_in_ip.to_s)
  end
end
