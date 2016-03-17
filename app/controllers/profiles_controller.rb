class ProfilesController < ApplicationController
  
  FORMS = ["name_and_email", "interests", "living_situation", "availability", "checkout", "summary"]
  
  def create
    # @email = params[:profile][:email]
    # if User.find_by_email(@email)

    # end
    @profile = Profile.new(profile_params)
    if @profile.save

      render_response
    else
      @response = {form: FORMS[session[:profile_step]], method: :post}
      render "profiles/update.js", content_type: "text/javascript"
    end
    # @user = User.create(email: params[:profile][:email], password: "domino2016", password_confirmation: "domino2016", role: "lead")
    #errors
  end

  def update
    @profile = Profile.find(params[:id])
    @profile.update(profile_params)
    #update user email also if changed
    # if params[:profile][:email] != @profile.user

    # end
    # @context = context params[:form]
    render_response
  end

  private

  def render_response
    @response = get_response
    render "profiles/update.js", content_type: "text/javascript"
  end

  def get_response
    @back = (params[:commit] == 'back') 
    @back ? session[:profile_step] -= 1 : session[:profile_step] += 1
    
    {form: FORMS[session[:profile_step]], method: :put}
  end

  def render_same_response
    {form: FORMS[session[:profile_step]], method: :put}
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
      :partner_code
    )
  end
end