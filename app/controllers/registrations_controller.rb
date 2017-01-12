class RegistrationsController < Devise::RegistrationsController
  
  # Action /new_org_member/
  # GET mydomino.com/[company name]
  # Purpose: Organziation landing page for org member onboarding
  def new_org_member
    # Grab organization name from url
    @org_name = request.original_url.split('/').last
    @organization = Organization.where('lower(name) = ?', @org_name.downcase).first

    # Case: Unique sign up link with user auth token
    # Check auth token
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

      Profile.create(
        user: @user,
        email: @email,
        first_name: @first_name,
        last_name: @last_name
      )

      #sign in newly created user
      sign_in(@user, scope: :user)

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
  #   Checks that submitted email has same domain as organization
  #   Checks if a user account already exists for the provided email address
  #   If a user account exists, generate unique sign up link and provide relevant feedback
  #   If a user account doesn't exist, user will be prompted for setting first name, last name,
  #   and password.
  def check_org_member_email
    # TODO check email domain against org domain
    @organization = Organization.find(params[:organization_id])

    @user = User.find_by_email(params[:email])

    message = @user ? "account exists" : "no account exists"
    
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