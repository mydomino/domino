class ProfilesController < ApplicationController
  before_action :set_profile, only: [:update, :apply_partner_code, :welcome_email]
  layout 'concierge', only: :new
  FORMS = ["name_and_email", "interests", "living_situation", "checkout", "summary"]
  
  def new
    @profile = Profile.new
  end

  def create_completed_profile
    @profile = Profile.new(profile_params)
    @profile.onboard_complete = true
    @profile.onboard_step = 4

    #don't send Stephen email when a user profile/dashboard is created 
    Profile.skip_callback(:create, :after, :send_onboard_started_email)
    if @profile.save
      Profile.set_callback(:create, :after, :send_onboard_started_email)
      create_dashboard(@profile)
      # Dashboard.create(lead_name: "#{@profile.first_name} #{@profile.last_name}", lead_email: @profile.email)
      @profile.save_to_zoho if params[:save_to_zoho]
      UserMailer.welcome_email_universal(@profile.email).deliver_later if params[:send_welcome_email]
      flash[:notice] = 'Dashboard created successfully'
      redirect_to dashboards_path
      return
    else
      Profile.set_callback(:create, :after, :send_onboard_started_email)
      render action: 'new', layout: 'concierge'
      return
    end
  end
  
  def create
    #handle onboarding edge cases 
    @email = (params[:profile][:email]).downcase
    return if legacy_user?
    return if user_already_registered?
    return if onboarding_incomplete?
    return if onboarded_but_not_registered?
    
    #create new profile
    set_tracking_variables
    @profile = Profile.create(profile_params)
    render_response and return
  end

  def update
    @profile.update_zoho if @profile.onboard_complete
 
    params[:commit] == 'Back' ? @profile.onboard_step -= 1 : @profile.onboard_step += 1

    case @profile.onboard_step
    when 2, 4
      apply_partner_code(false) if params[:profile] && params[:profile][:partner_code]
    when 3
      @partner_code = PartnerCode.find_by_id(@profile.partner_code_id)
      #allocate default dashboard
      create_dashboard(@profile)
      #send welcome email
      UserMailer.welcome_email_universal(@profile.email).deliver_later

      @profile.update(onboard_complete: true)
      @profile.save_to_zoho
    end

    @profile.update(profile_params)
    render_response
  end

  def apply_partner_code(render_js=true)
    @partner_code_param = params[:profile][:partner_code].upcase
    @partner_code = PartnerCode.find_by_code(@partner_code_param)
    if @partner_code
      @profile.update(partner_code_id: @partner_code.id)
      render 'profiles/apply_partner_code.js', content_type: "text/javascript" if render_js
    end
  end

  def welcome_email
    UserMailer.welcome_email_universal(@profile.email).deliver_later
    render "profiles/email_sent.js", content_type: 'text/javascript'
  end

  private

  def create_dashboard(profile)
    Dashboard.create(lead_name: "#{profile.first_name} #{profile.last_name}", lead_email: profile.email)
  end

  def legacy_user? 
    if @lu = LegacyUser.find_by_email(@email)
      if !@lu.dashboard_registered
        render :js => "window.location ='/users/sign_up?email=#{@lu.email}'"
      else
        flash[:notice] = "You have already signed up."
        render :js => "window.location = '/users/sign_in'"
      end
      return true
    end
    return false
  end

  def user_already_registered?
    if User.find_by_email(@email)
      flash[:notice] = "You have already signed up."
      render :js => "window.location = '/users/sign_in'" 
      return true
    end
    return false
  end

  def onboarding_incomplete?
    #user has begun, but not completed onboarding
    if (@profile = Profile.find_by_email(@email)) && !@profile.onboard_complete
      flash.now[:notice] = "Welcome back, #{@profile.first_name.capitalize}! Here is where you left off."
      render_response
      return true
    end
    return false
  end

  def onboarded_but_not_registered?
    if (@profile = Profile.find_by_email(@email)) && @profile.onboard_complete
      @profile.update(onboard_step: 4) if @profile.onboard_step < 4
      render_response
      return true
    end
    return false
  end

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def set_tracking_variables
    session[:ip]          ||= request.remote_ip
    session[:referer]     ||= request.referer
    session[:browser]     ||= request.user_agent
  end

  def interest_form_resources
    @active_inputs = @profile.interests.map {|i| i.offering_id }
    @offerings = Offering.all.map {|o| o.name }
  end

  def render_response
    interest_form_resources if @profile.onboard_step == 1 
    @response = {form: FORMS[@profile.onboard_step], method: :put}
    render "profiles/update.js", content_type: "text/javascript"
    return
  end

  def profile_params
    params.require(:profile).permit(
      :first_name, 
      :last_name, 
      :email, 
      {:offering_ids => []}, 
      :address_line_1, 
      :city, 
      :state, 
      :zip_code, 
      :phone,
      :housing,
      :avg_electrical_bill,
      :partner_code_id
    ).merge(session_params)
  end
end