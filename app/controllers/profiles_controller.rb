class ProfilesController < ApplicationController
  
  FORMS = ["name_and_email", "interests", "living_situation", "availability", "checkout", "summary"]
  
  def create
    #todo case user has completed onboarding
    #case user has started onboarding but hasn't completed
    if @profile = Profile.find_by_email(params[:profile][:email])
      flash[:message] = "Welcome back! Please complete your profile."
      continue_onboard
    else
      @profile = Profile.new(profile_params)
      @profile.onboard_complete = false;
      @profile.onboard_step = 0;
      @profile.build_availability
      @profile.avg_electrical_bill = 0;
      
      if @profile.save
        @profile.update(onboard_step: 1);
        render_response
      else
        @response = {form: FORMS[@profile.onboard_step], method: :post}
        render "profiles/update.js", content_type: "text/javascript"
      end
    end
    
    # @user = User.create(email: params[:profile][:email], password: "domino2016", password_confirmation: "domino2016", role: "lead")
    #errors
  end

  def update
    @profile = Profile.find(params[:id])
    @back = (params[:commit] == 'BACK') 
    @back ? @profile.onboard_step -= 1 : @profile.onboard_step += 1

    if @profile.onboard_step == 5 
      @profile.onboard_complete = true
      UserMailer.registration_email(@profile.email).deliver_later
    end
    
    @profile.update(profile_params)
    #update user email also if changed
    # if params[:profile][:email] != @profile.user

    # end
    # @context = context params[:form]
    #todo render same for with errors in case update cannot be performed
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

  def validate_partner_code(code)
    @partner_code = PartnerCode.find_by_code(code)
    @partner_code.nil? 
  end

  def render_response
    if @profile.onboard_step == 1 
      @active_inputs = @profile.interests.map {|i| i.offering_id }
      @offerings = Offering.all.map {|o| o.name }
    end
    @response = {form: FORMS[@profile.onboard_step], method: :put}
    render "profiles/update.js", content_type: "text/javascript"
  end

  def continue_onboard
    @response = {form: FORMS[@profile.onboard_step], method: :put}
    render "profiles/update.js", content_type: "text/javascript"
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