class ProfilesController < ApplicationController
  before_action :set_profile, only: [:apply_partner_code, :update, :resend_welcome_email]
  before_action :authenticate_user!, only: [:show, :myhome]
  
  layout 'concierge', only: :new
  
  # /show/ 
  # Purpose: This is the member profile info page
  # GET /profile
  def show
    @profile = current_user.profile
  end

  # /myhome/
  # Purpose: This is the membership home page
  # GET /myhome
  def myhome
    # @user used to display membership type, member since, and renewal date info
    @user = current_user
    # @profile used to display first and last name
    @profile = @user.profile
    @leaderboard_users = cfp_ranking

    #date to display on FAT module
    beginning_of_week = Date.today.beginning_of_week
    @week_of = "Week of " + beginning_of_week.strftime("%B #{beginning_of_week.day.ordinalize}")

    #fat timeline data

    time_zone_name = Time.zone.name
    time_now = Time.now.in_time_zone(time_zone_name)
    today = Date.new(time_now.year, time_now.month, time_now.day)

    active_days = today.cwday

    days_left = 7 - today.cwday
    fat_graph_date = today - active_days + 1
    @timeline_params = []

    active_days.times do
      meal_day_t = MealDay.find_by(date: fat_graph_date, user: current_user)
      day = fat_graph_date.strftime("%A").downcase
      status = meal_day_t ? "complete" : "incomplete"
      link = "/food/" + fat_graph_date.strftime("%Y/%m/%d")
      @timeline_params << { day: day , status: status, link: link }
      fat_graph_date += 1.day
    end

    days_left.times do 
      @timeline_params << {day: fat_graph_date.strftime("%A").downcase, status: "future", link: "#"}
      fat_graph_date += 1.day
    end

    # If its users first time signing in, give them the tour of myhome
    @tour = (current_user.sign_in_count == 1)

  end

  def verify_current_password
    valid = current_user.valid_password? params[:current_password]
    if valid
      render json: {
        message: "Current password field valid",
        status: 200
      }, status: 200
    else
      render json: {
        error: "Current password field invalid",
        status: 400
      }, status: 400
    end
  end

  def update_password
    @user = current_user
    @user.update(
      password: params[:updated_password],
      password_confirmation: params[:updated_password]
    )
  
    # keep user logged in
    sign_in(@user, :bypass => true)
    
    render json: {
      message: "Password updated successfully",
      status: 200
    }, status: 200
  end

  def edit
  end

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
    return if user_already_registered?
    return if onboarding_incomplete?
    return if onboarded_but_not_registered?
    
    #create new profile
    set_tracking_variables
    @profile = Profile.create(profile_params)
    session[:profile] = {id: @profile.id}

    # render_response and return
    redirect_to profile_step_path(@profile, Profile.form_steps.first)
  end

  def update
    # Updates via member profile info page
    if request.xhr?
      xhr_profile_params = JSON.parse(params["updated_fields"]["profile"].to_json)
      if @profile.update(xhr_profile_params)
        render json: {
          message: "Profile updated successfully",
          status: 200
        }, status: 200
      else
        render json: {
          message: "Unable to update profile.",
          status: 400
        }, status: 400
      end
    # Updates via onboarding
    else
      @profile.update(profile_params)
      redirect_to profile_step_path(@profile, Profile.form_steps.first)
    end
  end

  def apply_partner_code(render_js=true)
    @partner_code_param = params[:profile][:partner_code].upcase
    @partner_code = PartnerCode.find_by_code(@partner_code_param)
    if @partner_code
      @profile.update(partner_code_id: @partner_code.id)
      render 'profiles/apply_partner_code.js', content_type: "text/javascript" if render_js
    end
  end

  def resend_welcome_email
    UserMailer.welcome_email_universal(@profile.email).deliver_later
  end

  private

  # /cfp_ranking/
  # Purpose: returns list of users to be displayed on the leaderboard
  def cfp_ranking
    organization = current_user.organization

    #if organization.nil?
    #  # find the default organization
    #  organization = Organization.find_by!(name: 'MyDomino')
    #end

  
    # use background job to perform point calculations
    CalculateFatTotalPointJob.perform_later organization

    # find users with or without organization 
    @users = User.includes(:profile).where(organization: organization).order("fat_reward_points DESC").first(6)
    
    
    if ( !@users.any?{|u| u.email == current_user.email} )
      @users << current_user
      @current_user_standing = @users.index{|u| u.email == current_user.email}
    end
    @users
  end

  def create_dashboard(profile)
    Dashboard.create(lead_name: "#{profile.first_name} #{profile.last_name}", lead_email: profile.email)
  end

  def user_already_registered?
    if User.find_by_email(@email)
      flash[:notice] = "You have already signed up."
      redirect_to new_user_session_path
      return true
    end
    return false
  end

  def onboarding_incomplete?
    #user has begun, but not completed onboarding
    if (@profile = Profile.find_by_email(@email)) && !@profile.onboard_complete
      flash[:notice] = "Welcome back, #{@profile.first_name.capitalize}! Here is where you left off."
      redirect_to profile_step_path(@profile, Profile.form_steps[@profile.onboard_step-1])
      return true
    end
    return false
  end

  def onboarded_but_not_registered?
    if (@profile = Profile.find_by_email(@email)) && @profile.onboard_complete
      redirect_to profile_step_path(@profile, Profile.form_steps.last)
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

  def profile_params
    params.require(:profile).permit(
      :first_name, 
      :last_name, 
      :email,
      :phone,
      :address_line_1,
      :city,
      :state,
      :zip_code,
      {:offering_ids => []},
      :housing,
      :avg_electrical_bill,
      :partner_code_id
    ).merge(session_params)
  end
end