class RegistrationsController < Devise::RegistrationsController
  
  # Action /new_org_member/
  # GET mydomino.com/[company name]
  # Purpose: Organziation landing page for org member onboarding
  def new_org_member
    # Grab organization name from url
    # Account for query string parameters as users may have navigated 
    #   to this view with signup link
    @org_name = request.original_url.split('?').first.split('/').last
    @organization = Organization.where('lower(name) = ?', @org_name.downcase).first
    @org_email_domain = @organization.email.split("@").last

    # Case: Unique sign up link with user auth token
    # If authtoken invalid redirect to error page
    # Else Store auth token in sess variable
    # NOTE: find by signup token, remove email from signup link
    if params[:email]
      @user = User.includes(:profile).find_by_email(params[:email])
      if @user
        @user = nil unless @user.signup_token == params[:a]
      end
    end
  end
  
  # Action /set_org_member_password/
  # PATCH /set-org-member-password XmlHttpRequest
  # Purpose: Allow org members to set their passwords via signup link
  #   These are org members who have had user resources created for them
  #   by an org admin
  def set_org_member_password
    @user = User.includes(:profile).find_by_email(params[:email])

    # Update users password and set signup_token to nil
    # Setting signup_token to nil invalidates sign up link
    # used by the user.
    @user.update(
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      signup_token: nil
    )
    @user.profile.update(dashboard_registered: true)

    sign_in(@user, scope: :user)
    flash[:notice] = 'Welcome to MyDomino!'

    render json: {
      message: 'User password updated',
      status: 200
    }, status: 200
  end

  # Action /create_org_member/
  # POST /create-org-member XmlHttpRequest
  # Purpose: Creates organization member and provisions Dashboard, and Profile resources
  def create_org_member
    @organization = Organization.find(params[:organization_id].to_i)
    @email = params[:email]

    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @pw = params[:password]
    @pw_confirmation = params[:password_confirmation]

    # TODO check if authtoken is in sess variable
    # If so, only update user password
    
    # Allocate User account, dashboard, and profile 
    @user = User.create(
      email: @email,
      password: @pw,
      password_confirmation: @pw_confirmation,
      organization: @organization
    )

    if @user
      Dashboard.create(
        lead_email: @email, 
        lead_name: "#{@first_name} #{@last_name}",
        user: @user
      )

      profile = Profile.create(
        user: @user,
        email: @email,
        first_name: @first_name,
        last_name: @last_name,
        dashboard_registered: true
      )

      # Create zoho lead record
      ZohoService.save_to_zoho(profile)

      #sign in newly created user
      sign_in(@user, scope: :user)
      flash[:notice] = 'Welcome to MyDomino!'
      
      render json: {
        message: 'User added',
        status: 200
      }, status: 200
    else
      render json: {
        message: 'Error adding user',
        status: 400
      }, status: 400
    end
  end

  # Action /create_org_member_email/
  # GET /check-org-member-email XmlHttpRequest
  # Purpose: Checks submitted org member email. 
  #   Checks if a user account already exists for the provided email address
  #   If a user account exists, generate unique sign up link and provide relevant feedback
  #   If a user account doesn't exist, user will be prompted for setting first name, last name,
  #   and password.
  def check_org_member_email
    @user = User.find_by_email(params[:email])

    # If user account exists, send signup link email
    if @user 
      message = "account exists"
      @user.email_signup_link
    else
      message = "no account exists"
    end

    render json: {
      message: message,
      status: 200
    }, status: 200
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

  # /after_sign_up_path_for/
  # This action is hit after a user registers through the devise registration form
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