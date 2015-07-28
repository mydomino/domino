class SessionsController < ApplicationController
  before_action :start_timing
  caches_page :about

  def index
  end

  def getstarted
    set_tracking_variables
  end

  def signup
    @lead = FormSubmission.new(signup_params)
    @lead.save
    render :signup
  end

  private

  def set_tracking_variables
    session[:ip]          ||= request.remote_ip
    session[:campaign]    ||= request['utm_campaign']
    session[:referer]     ||= request.referer
    session[:browser]     ||= request.user_agent
  end

  def start_timing
    session[:start_time]  ||= Time.now
  end

  def signup_params
    keys = %i(ip referer browser start_time campaign)
    session_params = keys.each_with_object({}) do |str, hsh|
      hsh[str] = session[str]
    end
    params.permit(:name, :email, :address).merge(session_params)
  end

end
