class ApplicationController < ActionController::Base
  include Pundit
  # after_action :verify_authorized
  # skip_authorization if devise_controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :start_timing, :capture_utm_campaign
  layout :layout_by_resource

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def after_sign_in_path_for resource
    #Background job?
    #Heap.identify(current_concierge.email, name: current_concierge.name, role: "Concierge")
    # stored_location_for(resource) ||
    # byebug
    # if resource.is_a? AdminUser
    #   admin_root_path
    if resource.role == 'concierge'
      dashboards_path
    else
      user_dashboard_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def layout_by_resource
    if devise_controller? && resource_name == :concierge
      "blank"
    else
      "application"
    end
  end

  def start_timing
    session[:start_time]  ||= Time.now
  end

  def capture_utm_campaign
    session[:campaign] = request['utm_campaign'] if !request['utm_campaign'].nil?
    session[:campaign] = 'adwords' if !request['gclid'].nil?
  end

  def session_params
    keys = %i(ip referer browser start_time campaign)
    keys.each_with_object({}) do |str, hsh|
      hsh[str] = session[str]
    end
  end
end
