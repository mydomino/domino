class ApplicationController < ActionController::Base
  include Pundit
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :capture_utm_campaign, :get_user_agent
  around_action :handle_exceptions

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Let views access current_user
  helper_method :article_for_member_only?

  def article_for_member_only?(category)

    return category.include?(DHHtp::MEMBER_ONLY_CATEGORY)
    
  end

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

    #Rails.logger.debug "A. request.referer is #{request.referer.inspect}\n\n"
    #Rails.logger.debug "A. session[:paywall_url] is #{session[:paywall_url].inspect}\n\n"

    # If user was trying to read member only article, then redirect user to last read paywall 
    # URL after signing in.
    if session[:paywall_url] != nil
      #Rails.logger.debug "session[:paywall_url] is #{session[:paywall_url].inspect}\n\n"
      
      redirect_url = session[:paywall_url]

      # Now the user had signed in, let's reset the session paywall_url so it is only good for current action
      session[:paywall_url] = nil

      redirect_url
    elsif resource.role == 'concierge'
      #Rails.logger.debug "dashboards_path is #{dashboards_path.inspect}\n\n"
      dashboards_path
    else

      #Rails.logger.debug "user_dashboard_path is #{user_dashboard_path.inspect}\n\n"
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

  private

  def handle_exceptions
    begin
      yield

    #Rescue StandardError
    rescue => e
      Airbrake.notify(e)
      Rails.logger.error "Error: #{e.message}"
      Rails.logger.error  "#{e.backtrace.join("\n")}"
      redirect_to '/error'
    end
  end
end
