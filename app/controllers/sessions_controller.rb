class SessionsController < Devise::SessionsController

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