class RegistrationsController < Devise::RegistrationsController
  # layout 'concierge'
  
  def new
    #check if user completed onboarding
    #check if user already registered
    @email = params[:email]
    if User.find_by_email(@email)
      redirect_to new_user_session_path
    else
      @profile = Profile.find_by_email(@email)
      if @profile
        if @profile.onboard_complete
          super
        else
          #continue onboarding
        end
      else
        redirect_to '/'
      end
    end

  end

  def create
    #create dashboard for user
    # dashboard = Dashboard.create
    # # # @dashboard.concierge = current_concierge
    # dashboard.products = Product.default
    # dashboard.tasks = Task.default
    # user.dashboard=
    super
    # byebug
    #bind profile to user
    current_user.profile = Profile.find_by_email(current_user.email)
    #bind dashboard to user
    current_user.dashboard = Dashboard.create
    current_user.dashboard.products = Product.default
    current_user.dashboard.tasks = Task.default
  end

  def after_sign_up_path_for(resource)
    dashboard_path
  end
  
  protected

    def after_update_path_for(resource)
      edit_concierge_path
    end

end