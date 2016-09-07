class RegistrationsController < Devise::RegistrationsController
  
  def new
    #redirect to root if no slug or email in params
    redirect_to root_path and return if !(params[:slug] || params[:email])

    if params[:slug]
      # @legacy_user = true
      @dashboard = Dashboard.find_by_slug(params[:slug])
      @dashboard ? @email = @dashboard.lead_email : (redirect_to root_path and return)         
    else
      @email = params[:email].downcase
      @legacy_user = true if LegacyUser.find_by_email(@email)
    end

    #check if user already registered, if so redirect to login page
    #TODO should add flash message you already have an account
    redirect_to new_user_session_path and return if User.find_by_email(@email)
    
    #todo should return to complete onboarding
    if @profile = Profile.find_by_email(@email)
      @profile.onboard_complete ? (super and return) : (redirect_to "/continue/#{@profile.id}" and return)
    end

    #case where legacy users don't have a profile
    if LegacyUser.find_by_email(@email)
      super and return
    else
      redirect_to root_path and return
    end
  end

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
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
      redirect_to new_user_registration_path(email: resource.email)
    end
  end

  def after_sign_up_path_for(resource)
    if current_user

      @email = current_user.email
      @profile = Profile.find_by_email(@email)

      current_user.profile = @profile if !@profile.nil?
      
      #create and bind dashboard to user if not legacy user
      if !LegacyUser.find_by_email(@email)
        current_user.dashboard = Dashboard.create(lead_name: "#{current_user.profile.first_name} #{current_user.profile.last_name}", lead_email: @email)
        current_user.dashboard.products = Product.default
        current_user.dashboard.tasks = Task.default
        @profile.update(dashboard_registered: true)
        DashboardRegisteredZohoJob.perform_later @profile
      else
        current_user.dashboard = Dashboard.find_by_lead_email(@email)
        lu = LegacyUser.find_by_email(@email)
        lu.update(dashboard_registered: true)
        @profile.update(dashboard_registered: true) if !@profile.nil?
      end
      user_dashboard_path
    else
      root_path
    end
  end

end