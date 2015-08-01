class LeadsController < ApplicationController
  def new
    set_tracking_variables
  end

  def create
    @lead = FormSubmission.new(signup_params)
    @lead.save
    render :signup
  end

  private

  def set_tracking_variables
    session[:ip]          ||= request.remote_ip
    session[:referer]     ||= request.referer
    session[:browser]     ||= request.user_agent
  end

  def signup_params
    keys = %i(ip referer browser start_time campaign)
    session_params = keys.each_with_object({}) do |str, hsh|
      hsh[str] = session[str]
    end
    params.permit(:name, :email, :address).merge(session_params)
  end
end