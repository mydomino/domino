class RegistrationsController < Devise::RegistrationsController
  
  def new

    #users may only register if they complete onboarding
    redirect_to root_path if !@email = params[:email]
    #check if user already registered, if so redirect to login page
    redirect_to new_user_session_path if User.find_by_email(@email)
    
    @profile = Profile.find_by_email(@email)
    @profile.onboard_complete ? super : (redirect_to root_path)

  end

  def create
    super
    #bind profile to user
    current_user.profile = Profile.find_by_email(current_user.email)
    #create and bind dashboard to user
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