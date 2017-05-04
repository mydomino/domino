class SessionsController < Devise::SessionsController
  def new
    # Store path of referer in session var
    # For redirection back to article views
    (session[:referer] = URI(request.referer).path) if request.referer
    super

    track_event "Load login page", {"date": Time.zone.today}
  end
end
