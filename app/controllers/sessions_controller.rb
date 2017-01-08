class SessionsController < Devise::SessionsController

  def new
    # Store path of referer in session var
    # For redirection back to article views
    (session[:referer] = URI(request.referer).path) if request.referer
    super
  end

  # Note: after this function, after_sign_in_path_for method is called
  def create
    @email = params[:user][:email]
    #if legacy user attempts to login, but has not registered a password
    #redirect to sign up path
    @lu = LegacyUser.find_by_email(@email)
    if @lu && !@lu.dashboard_registered
      redirect_to "/users/sign_up?email=#{@email}" and return
    end
    super
  end

end