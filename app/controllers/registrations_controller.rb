class RegistrationsController < Devise::RegistrationsController
  
  # Corp member registration
  def new_org_member
    @company_name = request.original_url.split('/').last.capitalize
  end

  def new
    # Redirect to root path if no slug or email in params
    # Email param comes from sign up link thats generated after a user completes
    # onboarding (i.e. https//mydomino.com/users/sign_up?email=[percent encoded email address])
    # TODO: Figure out where slug param comes from
    redirect_to root_path and return if !(params[:slug] || params[:email])

    # If sthe slug param is provided, it means that a user was a previous user of mydomino,
    # prior to adding devise authentication. Grab the email associated with the dashboard for
    # registration
    if params[:slug]
      @dashboard = Dashboard.find_by_slug(params[:slug])
      if @dashboard
        @email = @dashboard.lead_email
      else 
        redirect_to root_path and return
      end         
    else
      @email = params[:email].downcase
      @legacy_user = true if LegacyUser.find_by_email(@email)
    end

    #check if user already registered, if so redirect to login page
    #TODO should add flash message you already have an account
    redirect_to new_user_session_path and return if User.find_by_email(@email)
    
    if @profile = Profile.find_by_email(@email)
      @profile.onboard_complete ? (super and return) : (redirect_to "/continue/#{@profile.id}" and return)
    end

    # Case where legacy users don't have a profile
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
    @email = current_user.email
    @profile = Profile.find_by_email(@email)

    current_user.profile = @profile if !@profile.nil?
    
    #create and bind dashboard to user if not legacy user
    if !LegacyUser.find_by_email(@email)
      #assign provisioned dashboard to newly registered user
      if dashboard = Dashboard.find_by_lead_email(@email)
        current_user.dashboard = dashboard
      else
        #if dashboard hasn't been allocated (i.e. imported lead) create one
        current_user.dashboard = Dashboard.create(lead_name: "#{@profile.first_name} #{@profile.last_name}", lead_email: @profile.email)
      end

      @profile.update(dashboard_registered: true)
      DashboardRegisteredZohoJob.perform_later @profile
    else
      #bind legacy user's dashboard to their newly created user account
      current_user.dashboard = Dashboard.find_by_lead_email(@email)
      lu = LegacyUser.find_by_email(@email)
      lu.update(dashboard_registered: true)
      @profile.update(dashboard_registered: true) if !@profile.nil?
    end
    user_dashboard_path
  end

end