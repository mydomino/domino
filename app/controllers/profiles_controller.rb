class ProfilesController < ApplicationController
  before_action :set_profile, only: [:update, :apply_partner_code]
  FORMS = ["name_and_email", "interests", "living_situation", "checkout", "summary"]
  
  def create
    #if legacy user attempts to onboard, redirect to sign up or sign in
    if @lu = LegacyUser.find_by_email(params[:profile][:email])
      if !@lu.dashboard_registered
        render :js => "window.location ='/users/sign_up?email=#{@lu.email}'"
      else
        render :js => "window.location = '/users/sign_in'"
        flash[:notice] = "You have already signed up."
      end
      return 
    end

    if @profile = Profile.find_by_email(params[:profile][:email])
      #user has already registered
      if User.find_by_email(@profile.email)
        render :js => "window.location = '/users/sign_in'" 
        return
      else
      #user has not completed onboarding
      # if !@profile.onboard_complete
      #   flash.now[:message] = "Welcome back! Please complete your profile."
      #   continue_onboard
      # else
        #edge case where users complete onboarding but haven't yet registered as user
        @response = {form: FORMS[4]}
        render "profiles/update.js", content_type: "text/javascript"
        return
      end
    else
      set_tracking_variables
      @profile = Profile.new(profile_params)
      @profile.onboard_complete = true #onboard complete if user submits name and email
      if @profile.save #validations
        render_response
        return false
      else
        @response = {form: FORMS[0], method: :post}
        render "profiles/update.js", content_type: "text/javascript"
        return
      end
    end
  end

  def update
    @back = (params[:commit] == 'BACK') 
    @back ? @profile.onboard_step -= 1 : @profile.onboard_step += 1

    if @profile.onboard_step == 3
      @partner_code = PartnerCode.find_by_id(@profile.partner_code_id)
    end

    if (@profile.onboard_step == 2 || @profile.onboard_step == 4)
       apply_partner_code(false) if params[:profile] && params[:profile][:partner_code]
    end
    if @profile.onboard_step == 4 
      UserMailer.welcome_email_universal(@profile.email).deliver_later
    end
    
    @profile.update(profile_params)
    render_response
  end

  def apply_partner_code(render_js=true)
    @partner_code_param = params[:profile][:partner_code].upcase
    @partner_code = PartnerCode.find_by_code(@partner_code_param)
    # @code_valid = !PartnerCode.find_by_code(@partner_code).nil?
    if @partner_code
      @profile.update(partner_code_id: @partner_code.id)
      render 'profiles/apply_partner_code.js', content_type: "text/javascript" if render_js
    end
  end

  def welcome_email
    @profile = Profile.find(params[:profile_id])
    UserMailer.welcome_email_universal(@profile.email).deliver_later
    render "profiles/email_sent.js", content_type: 'text/javascript'
  end

  def lu_registration_email
    @lu = LegacyUser.find(params[:lu_id])
    UserMailer.legacy_user_registration_email_universal(@lu.email).deliver_later
    render "profiles/email_sent.js", content_type: 'text/javascript'
  end

  private

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

  # def continue_onboard
  #   @profile.update(onboard_step: 1)
  #   render_response
  # end

  def profile_params
    params.require(:profile).permit(
      :first_name, 
      :last_name, 
      :email, 
      {:offering_ids => []}, 
      :address_line_1, 
      :address_line_2, 
      :city, 
      :state, 
      :zip_code, 
      :phone,
      :housing,
      :avg_electrical_bill,
      :comments
    ).merge(session_params)
  end
end