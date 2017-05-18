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
  end
end
