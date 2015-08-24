class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :start_timing, :capture_utm_campaign

  private  

  def start_timing
    session[:start_time]  ||= Time.now
  end

  def capture_utm_campaign
    return if !session[:campaign].nil?
    session[:campaign] = request['utm_campaign'] if !request['utm_campaign'].nil?
    session[:campaign] = 'adwords' if !request['gclid'].nil?
  end

end
