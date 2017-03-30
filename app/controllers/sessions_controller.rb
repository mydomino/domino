class SessionsController < Devise::SessionsController
  def new
    # Store path of referer in session var
    # For redirection back to article views
    (session[:referer] = URI(request.referer).path) if request.referer
    super

    puts "***************User signed in"
    track_event "User signed in"
  end
end
