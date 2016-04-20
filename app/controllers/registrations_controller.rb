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
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        #set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      flash[:error] = resource.errors.full_messages.join("<br>")
      # flash[:error] = resource.errors.full_messages.map { |msg| msg }
      redirect_to new_user_registration_path(email: resource.email)
    end
  end

  # def create
  #   super
  #   #bind profile to user
  #   if current_user
  #     current_user.profile = Profile.find_by_email(current_user.email)
  #     #create and bind dashboard to user
  #     current_user.dashboard = Dashboard.create(lead_name: "#{current_user.profile.first_name} #{current_user.profile.last_name}", lead_email: current_user.email)
  #     current_user.dashboard.products = Product.default
  #     current_user.dashboard.tasks = Task.default
  #     current_user.update(role: 'lead') #default role is lead 
  #   else #passsword not long enough
  #     # flash.keep
  #     flash.keep[:error] = 'test'
  #     #resource.errors.full_messages.join(" ")
  #   end
  # end

  def after_sign_up_path_for(resource)
    # byebug
    if current_user
      @profile = Profile.find_by_email(current_user.email)
      current_user.profile = @profile
#     #create and bind dashboard to user
      current_user.dashboard = Dashboard.create(lead_name: "#{current_user.profile.first_name} #{current_user.profile.last_name}", lead_email: current_user.email)
      @profile.update(dashboard_registered: true);
      current_user.dashboard.products = Product.default
      current_user.dashboard.tasks = Task.default
      current_user.update(role: 'lead') #default role is lead 
      user_dashboard_path
    else
      root_path
      #new_user_registration_path
    end
  end
  
  protected

  # def after_update_path_for(resource)
  #   edit_concierge_path
  # end

end