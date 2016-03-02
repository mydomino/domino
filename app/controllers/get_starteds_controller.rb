class GetStartedsController < ApplicationController
  before_filter :set_get_started, :update_get_started

  def step_1

  end

  def step_2
  end

  def step_3
    @lead = Lead.new(get_started: @get_started)
  end

  def finish
    set_tracking_variables
    @lead = Lead.new(lead_params)
    if @lead.save
      render :thank_you
    else
      render :step_3
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :address,
                                 :phone,
                                 :get_started_id,
                                 :subscribe_to_mailchimp).merge(session_params)
  end

  def set_tracking_variables
    session[:ip]          ||= request.remote_ip
    session[:referer]     ||= request.referer
    session[:browser]     ||= request.user_agent
  end

  def set_get_started
    if(session[:get_started_id].nil?)
      @get_started = GetStarted.create
      session[:get_started_id] = @get_started.id
    else
      @get_started = GetStarted.find(session[:get_started_id])
    end
  end

  def update_get_started
   if(!params[:get_started].nil?)
      @get_started.update_attributes(params[:get_started].permit(:solar, :energy_analysis, :area_code, :average_electric_bill))
    end
  end

end
