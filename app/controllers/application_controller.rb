class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :start_timing, :capture_utm_campaign
  layout :layout_by_resource


  private

  def after_sign_in_path_for concierge
    Heap.identify(current_concierge.email, name: current_concierge.name, role: "Concierge")
    dashboards_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_concierge_session_path
  end

  def layout_by_resource
    if devise_controller? && resource_name == :concierge
      "concierge"
    else
      "application"
    end
  end

  def start_timing
    session[:start_time]  ||= Time.now
  end

  def capture_utm_campaign
    return if !session[:campaign].nil?
    session[:source] = request['utm_campaign'] if !request['utm_campaign'].nil?
    session[:source] = 'adwords' if !request['gclid'].nil?
    session[:source] = '' if request['utm_campaign'].nil? && request['gclid'].nil?
  end

end
