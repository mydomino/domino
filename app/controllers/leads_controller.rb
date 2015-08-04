class LeadsController < ApplicationController
  def new
    set_tracking_variables
    @lead = Lead.new
  end

  def create
    @lead = Lead.create(lead_params)
    if(@lead.save)
      render :signup
    else
      flash[:alert] = 'There was an error'
      render :new
    end
  end

  private

  def set_tracking_variables
    session[:ip]          ||= request.remote_ip
    session[:referer]     ||= request.referer
    session[:browser]     ||= request.user_agent
  end

  def lead_params
    params.permit(:name, :email, :address).merge(session_params)
  end

  def session_params
    keys = %i(ip referer browser start_time campaign)
    keys.each_with_object({}) do |str, hsh|
      hsh[str] = session[str]
    end
  end
end