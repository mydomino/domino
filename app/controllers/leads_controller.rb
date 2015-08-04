class LeadsController < ApplicationController
  def new
    set_tracking_variables
    @lead = Lead.new
  end

  def create
    @lead = Lead.create(lead_params)
    @lead.save
    render :new_callback
  end

  private

  def set_tracking_variables
    session[:ip]          ||= request.remote_ip
    session[:referer]     ||= request.referer
    session[:browser]     ||= request.user_agent
  end

  def lead_params
    params.require(:lead).permit(:last_name, :email, :address, :phone).merge(session_params)
  end

  def session_params
    keys = %i(ip referer browser start_time campaign)
    keys.each_with_object({}) do |str, hsh|
      hsh[str] = session[str]
    end
  end
end