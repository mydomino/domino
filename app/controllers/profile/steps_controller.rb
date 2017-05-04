class Profile::StepsController < ApplicationController
  include Wicked::Wizard

  before_action :set_profile, only: [:show, :update]

  steps *Profile.form_steps

  def show
    if step == 'interests'
      @active_inputs = @profile.interests.map {|i| i.offering_id }
      @offerings = Offering.all.map {|o| o.name }
    end

    #Jump to summary view if user has onboarded, but tries again or attempts
    #to visit an onboarding URL
    if @profile.onboard_step ==  4 && step != "summary"
      jump_to(wizard_steps.last.to_sym)
    end

    render_wizard
  end

  def update
    @profile.update(profile_params(step))
    
    if @profile.onboard_complete
      @profile.update_zoho
    end

    if params[:commit] == 'Back'
      if step == 'interests'
        redirect_to root_path(:profile_id => @profile.id)
        return
      else
        @profile.onboard_step -= 1
        jump_to(previous_step.to_sym)
      end
    else
      @profile.onboard_step += 1
      if(!@profile.onboard_complete && step == 'your_house')
        @profile.onboard_complete = true
        Dashboard.create(lead_name: "#{@profile.first_name} #{@profile.last_name}", lead_email: @profile.email)
        @profile.save_to_zoho
        track_event "User completed onboarding"
      end

      if params[:profile][:partner_code]
        apply_partner_code(false)
      end
    end

    render_wizard @profile 
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def profile_params(step)
    permitted_attributes = case step
      when "interests"
        [{:offering_ids => []}]
      when "your_house"
        [ :address_line_1, :city, :state, 
          :zip_code, :phone, :housing,
          :avg_electrical_bill]
      when "checkout"
        [:partner_code_id]
      end

    params.require(:profile).permit(permitted_attributes).merge(form_step: step)
  end

  def apply_partner_code(render_js=true)
    @partner_code_param = params[:profile][:partner_code].upcase
    @partner_code = PartnerCode.find_by_code(@partner_code_param)
    if @partner_code
      @profile.update(partner_code_id: @partner_code.id)
      render 'profiles/apply_partner_code.js', content_type: "text/javascript" if render_js
    end
  end
end
