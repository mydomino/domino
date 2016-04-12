class RegistrationsController < Devise::RegistrationsController
  
  def new
    #check if user already registered, if so redirect to login page
    @email = params[:email]
    if User.find_by_email(@email)
      redirect_to new_user_session_path
    else #check if user completed onboarding
      if @profile = Profile.find_by_email(@email)
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
    super
    #bind profile to user
    current_user.profile = Profile.find_by_email(current_user.email)
    #bind dashboard to user
    current_user.dashboard = Dashboard.create(lead_name: "#{current_user.profile.first_name} #{current_user.profile.last_name}", lead_email: current_user.email)
    current_user.dashboard.products = Product.default
    current_user.dashboard.tasks = Task.default
    current_user.update(role: 'lead') #default role is lead 
  end

  def after_sign_up_path_for(resource)
    user_dashboard_path
  end
  
  protected

  def after_update_path_for(resource)
    edit_concierge_path
  end

end