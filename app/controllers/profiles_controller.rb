class ProfilesController < ApplicationController
  
  FORMS = ["name_and_email", "interests", "living_situation", "availability", "checkout", "summary"]
  
  def create
    # @email = params[:profile][:email]
    # if User.find_by_email(@email)

    # end
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
    @profile.onboard_step += 1;
    @profile.update(profile_params)
    #update user email also if changed
    # if params[:profile][:email] != @profile.user

    # end
    # @context = context params[:form]
    #todo render same for with errors in case update cannot be performed
    render_response
  end

  private

  def render_response
    @response = get_response
    render "profiles/update.js", content_type: "text/javascript"
  end

  def get_response
    @back = (params[:commit] == 'back') 
    @back ? @profile.onboard_step -= 1 : @profile.onboard_step += 1
    
    {form: FORMS[@profile.onboard_step], method: :put}
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