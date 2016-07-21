class PagesController < ApplicationController
  skip_after_action :verify_authorized
  layout 'example', only: :example

  FORMS = ["name_and_email", "interests", "living_situation", "checkout", "summary"]

  def index
    #continue onboarding
    if params.has_key?(:profile_id) && @profile = Profile.find(params[:profile_id])
      if @profile.onboard_step == 0
        Profile.skip_callback(:update, :after, :update_zoho)
        @profile.update(onboard_step: 1)
        Profile.set_callback(:update, :after, :update_zoho)
      end
      interest_form_resources if (@profile.onboard_step == 1)
      get_partner_code if (@profile.onboard_step == 3)
      flash.now[:notice] = "Welcome back, #{@profile.first_name.capitalize}! Here is where you left off."
      @response = {form: "profiles/#{FORMS[@profile.onboard_step]}", method: :put}
      return
    end
    @profile = Profile.new
    @response = {form: 'profiles/name_and_email', method: :post}
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def team
  end

  def faq
  end
  
  def example
  end

  private

  def interest_form_resources
    @active_inputs = @profile.interests.map {|i| i.offering_id }
    @offerings = Offering.all.map {|o| o.name }
  end

  def get_partner_code
    @partner_code = PartnerCode.find_by_id(@profile.partner_code_id)
  end

end
