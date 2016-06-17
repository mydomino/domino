class PasswordsController < Devise::PasswordsController
  def create
    @email = params[:user][:email]
    #dashboard not reg'd
    @lu = LegacyUser.find_by_email(@email)
    if @lu && !@lu.dashboard_registered
      redirect_to "/users/sign_up?email=#{@email}" and return
    end
    super
  end
end