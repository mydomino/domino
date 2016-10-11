class Profile::StepsController < ApplicationController
  include Wicked::Wizard

  steps *Profile.form_steps

  def show
    @profile = Profile.find(params[:profile_id])
    @active_inputs = @profile.interests.map {|i| i.offering_id }
    @offerings = Offering.all.map {|o| o.name }
    render_wizard
  end

  def update
    @profile = Profile.find(params[:profile_id])
    @profile.update(profile_params(step))
    if params[:commit] == 'Back'
      if step == 'interests'
        redirect_to root_path(:profile_id => @profile.id)
        return
      else
        puts "!!!!!!!!!!!!#{previous_step}"
        @profile.onboard_step -= 1
        jump_to(previous_step.to_sym)
      end
    end
    @profile.onboard_step -= 1
    render_wizard @profile 
  end

  private

  def profile_params(step)
    permitted_attributes = case step
      when "interests"
        [{:offering_ids => []}]
      when "living_situation"
        [ :address_line_1, :city, :state, 
          :zip_code, :phone, :housing,
          :avg_electrical_bill]
      when "checkout"
        [:partner_code_id]
      end

    params.require(:profile).permit(permitted_attributes).merge(form_step: step)
  end

end
