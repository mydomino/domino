class ProfilesController < ApplicationController
  FORMS = ["name_and_email", "interests", "living_situation", "availability", "checkout", "summary"]
  
  def create
    if @profile = Profile.find_by_email(params[:profile][:email])
      #todo edge case where users complete onboarding but haven't yet registered as user
      if User.find_by_email(@profile.email)
        render :js => "window.location = '/users/sign_in'"
      end
      if !@profile.onboard_complete
        flash.now[:message] = "Welcome back! Please complete your profile."
        continue_onboard
      end
    else
      @profile = Profile.new(profile_params)
      @profile.build_availability
      if @profile.save #validations
        render_response
      else
        @response = {form: FORMS[0], method: :post}
        render "profiles/update.js", content_type: "text/javascript"
      end
    end
  end

  def update
    @profile = Profile.find(params[:id])
    @back = (params[:commit] == 'BACK') 
    @back ? @profile.onboard_step -= 1 : @profile.onboard_step += 1

    if @profile.onboard_step == 4
      if @profile.partner_code
        @code_valid = PartnerCode.find_by_code(@profile.partner_code)
      else
        @code_valid = false
      end
    end  

    if @profile.onboard_step == 5 
      @profile.update(onboard_complete: true)
      UserMailer.welcome_email(@profile.email).deliver_later
    end
    
    @profile.update(profile_params)
    render_response
  end

  def apply_partner_code
    @profile = Profile.find(params[:id])
    @code_valid = validate_partner_code(params[:profile][:partner_code])
    if @code_valid
      @profile.update(profile_params)
      render 'profiles/apply_partner_code.js', content_type: "text/javascript"
    end
  end

  private

  def interest_form_resources
    @active_inputs = @profile.interests.map {|i| i.offering_id }
    @offerings = Offering.all.map {|o| o.name }
  end

  def validate_partner_code(code)
    @partner_code = PartnerCode.find_by_code(code)
    !@partner_code.nil? 
  end

  def render_response
    interest_form_resources if @profile.onboard_step == 1 
    @response = {form: FORMS[@profile.onboard_step], method: :put}
    render "profiles/update.js", content_type: "text/javascript"
  end

  def continue_onboard
    @profile.update(onboard_step: 1)
    render_response
  end
  
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
      {:availability_attributes => [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :morning, :afternoon, :evening] },
      :comments,
      :partner_code
    )
  end
end