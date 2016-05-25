class ApplicationController < ActionController::Base
  include Pundit
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :capture_utm_campaign, :get_user_agent

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  private

  def get_user_agent
    @user_agent = request.env['HTTP_USER_AGENT']
    @browser = Browser.new(@user_agent, accept_language: "en-us")
  end
  
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def after_sign_in_path_for resource
    if resource.role == 'concierge'
      dashboards_path
    else
      user_dashboard_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def capture_utm_campaign
    session[:campaign] = request['utm_campaign'] if !request['utm_campaign'].nil?
    session[:campaign] = 'adwords' if !request['gclid'].nil?
  end

  def session_params
    keys = %i(ip referer browser campaign)
    keys.each_with_object({}) do |str, hsh|
      hsh[str] = session[str]
    end
  end

end
