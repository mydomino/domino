class ApplicationController < ActionController::Base
  include Pundit
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :start_timing, :capture_utm_campaign, :capture_mail_host

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  private

  def capture_mail_host
    ActionMailer::Base.default_url_options = {:host => request.host_with_port}
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

  def start_timing
    session[:start_time]  ||= Time.now
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
