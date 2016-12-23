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

  def after_sign_in_path_for(resource)

    # If user logs in via article views, redirect to whichever article view they left off at
    if session[:referer] && session[:referer].include?('/articles')
      session[:referer]
    elsif resource.role == 'concierge'
      #Rails.logger.debug "dashboards_path is #{dashboards_path.inspect}\n\n"
      dashboards_path
    else
      #Rails.logger.debug "user_dashboard_path is #{user_dashboard_path.inspect}\n\n"
      user_dashboard_path
    end

  end

  def after_sign_out_path_for(resource)
    # Flash notice workaround so stale notice won't potentially 
    # appear in devise login/sign up forms
    flash[:notice] = nil
    
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

  def handle_exceptions
     begin
       yield

     rescue ActiveRecord::RecordNotFound => e
       log_error(e)
       redirect_to controller: 'errors', action: 'user_error', err_mesg: e.message

     rescue => e
       log_error(e)

       # this also works.... but it relies on the match statement in routes.rb
       redirect_to "/apperror?err_mesg=#{e.message}"
     
     end
  end


  def log_error(e)

    # only send Airbrake notification when not in development  
    Airbrake.notify(e) if !Rails.env.development?

    Rails.logger.error "Error occured! Exception error is #{e.inspect}. Error: #{e.message}"
    # do not need to log trace error
    #Rails.logger.error  "#{e.backtrace.join("\n")}"
    
  end
end
