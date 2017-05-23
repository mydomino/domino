class ProfilesController < ApplicationController
  include FatCompetition

  before_action :set_profile, only: [:apply_partner_code, :update, :resend_welcome_email]
  before_action :authenticate_user!, only: [:show, :challenges]

  layout 'concierge', only: :new

  # /show/
  # Purpose: This is the member profile info page
  # GET /profile
  def show
    @profile = current_user.profile
    @us_time_zones = ActiveSupport::TimeZone.us_zones.map {|tz| tz.name }
    @user = current_user
  end

  # /challenges/
  # Purpose: This is the membership home page
  # GET /challenges
  def challenges
    # @user used to display membership type, member since, and renewal date info
    @user = current_user
    @show_prev_timeline = request.cookies['prevtimeline'] == "true"
    
    # @profile used to display first and last name
    @profile = @user.profile

    # Leader board list
    @leaderboard_users = cfp_ranking

    #date to display on FAT module
    beginning_of_week = Date.today.beginning_of_week
    end_of_week = beginning_of_week + 6

    @week_of = beginning_of_week.strftime("%B #{beginning_of_week.day}") + " to " + end_of_week.strftime("%B #{end_of_week.day}")
    @deadline = Date.today.end_of_week + 1
    @deadline_lastweek = @deadline - 7

    #fat timeline data
    time_zone_name = Time.zone.name
    time_now = Time.now.in_time_zone(time_zone_name)
    today = Date.new(time_now.year, time_now.month, time_now.day)

    #get timeline of current week
    active_days = today.cwday
    days_left = 7 - today.cwday
    fat_graph_date = today - active_days + 1
    @timeline_params = fat_timeline_params(fat_graph_date, active_days, days_left) 
    
    # Get timeline of previous week if Mon 12am < current time < Mon 11pm
    if(time_now.send(FatCompetition::GRACE_PERIOD_DAY + '?') && time_now.hour < FatCompetition::GRACE_PERIOD_HOUR)
      @prev_week = true
      @prev_timeline_params = fat_timeline_params(fat_graph_date-7)
      @prev_week_of = (fat_graph_date-7).strftime("%B #{(fat_graph_date-7).day}") + " to " + (fat_graph_date-1).strftime("%B #{(fat_graph_date-1).day}") 
    end 

    # Welcome tour params
    @tour = !@profile.welcome_tour_complete
    @mobile = @browser.device.mobile? ? true : false

    # Display fat intro overlay if user has not joined food challenge yet
    @show_fat_intro = !@profile.fat_intro_complete
  end

  # /verify_current_password/
  # Purpose: Verify current password to allow password change via member profile
  # GET /profile/verify-current-password XMLHttpRequest
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

  # /update_password/
  # Purpose: Update user password via member profile
  # POST /profile/update-password XMLHttpRequest
  def update_password
    @user = current_user
    @user.update(
      password: params[:updated_password],
      password_confirmation: params[:updated_password]
    )

    # keep user logged in
    sign_in(@user, :bypass => true)

    @tracker.track(current_user.id, 'User updated password')
    render json: {
      message: "Password updated successfully",
      status: 200
    }, status: 200
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

  # /welcome_tour_complete/
  # Purpose: Set db flag indicating user has completed the myhome welcome tour
  # GET /profile/welcome-tour-complete XMLHttpRequest
  def welcome_tour_complete
    current_user.profile.update(welcome_tour_complete: true)

    render json: {
      message: "Welcome tour complete flag set",
      status: 200
    }, status: 200
  end

  def fat_intro_complete
    current_user.profile.update(fat_intro_complete: true)

    render json: {
      message: "Fat intro complete flag set",
      status: 200
    }, status: 200
  end


  def update_notifications

    @profile = current_user.profile
    @user = current_user

    Rails.logger.debug ("params[:user][:time] is #{params[:user][:time]}\n")
    Rails.logger.debug ("params[:user][:notification_ids] is #{params[:user][:notification_ids]}\n")

    # save user's selected notifications from checkbox
    if @user.update_attributes(notification_params)

      # update user's notification time
      #nu = @user.notification_users.where(notification_id: 2).first
      #nu.update_attributes(time: 1) if nu != nil

      
      redirect_to @profile, notice: "Updated Successfully."
    else
      # show error
      redirect_to @profile, notice: "Updated profile failed."
    end

  end


  private

  # /fat_timeline_params/
  def fat_timeline_params(start_date, active_days=nil, days_left=nil)

    tmp_timeline_params = [];
    
    if(!active_days.nil?)
      active_days.times do
        meal_day_t = MealDay.find_by(date: start_date, user: current_user)
        day = start_date.strftime("%A").downcase
        status = meal_day_t ? "complete" : "incomplete"
        link = "/food/" + start_date.strftime("%Y/%m/%d")
        tmp_timeline_params << { day: day , status: status, link: link }
        start_date += 1.day
      end

      days_left.times do 
        tmp_timeline_params << {day: start_date.strftime("%A").downcase, status: "future", link: "#"}
        start_date += 1.day
      end
    else 
      7.times do
        meal_day_t = MealDay.find_by(date: start_date, user: current_user)
        day = start_date.strftime("%A").downcase
        status = meal_day_t ? "complete" : "incomplete"
        link = "/food/" + start_date.strftime("%Y/%m/%d")
        tmp_timeline_params << { day: day , status: status, link: link }
        start_date += 1.day
      end
    end
    return tmp_timeline_params
  end

  # /cfp_ranking/
  # Purpose: returns list of users to be displayed on the leaderboard
  def cfp_ranking
    organization = current_user.organization

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
      :partner_code_id,
      :time_zone
    ).merge(session_params)
  end

  def notification_params
    params.require(:user).permit(
      {notification_ids:[]}
    )
  end

end
