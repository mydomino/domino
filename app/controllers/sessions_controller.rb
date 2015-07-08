class SessionsController < ApplicationController
  caches_page :index, :about

  def index
    # TODO: It should use pre-configured data for development environment
    ip = request.remote_ip
    # ip = '75.149.54.14' if ip == '127.0.0.1'
    # TODO: Temporarily disabling until we can install a better geolocator
    # @geolocation = GeoIp.geolocation(ip)
    @geolocation = {city: 'San Francisco', state: 'CA'}
    session[:ip] = ip
    session[:referer] ||= request.referer
    session[:browser] = request.user_agent
    session[:start_time] = Time.now
    session[:campaign] = request['utm_campaign']
    session[:city] = @geolocation[:city]
    session[:state] = @geolocation[:region_name]
    session[:zipcode] = @geolocation[:zip_code]
  end

  def calculate
    @location = SavingsLocation.find_by_params(params)
    %i(city state zipcode).each { |key| session[key] = @location[key] }
    render json: @location
  end

  def typeahead
    @location = SavingsLocation.find_city_info(params[:query])
    render json: @location
  end

  def signup
    @submission = FormSubmission.new(signup_params)
    @submission.save
    render :signup
  end

  private

  def signup_params
    keys = %i(ip city state zipcode referer browser start_time campaign)
    session_params = keys.each_with_object({}) do |str, hsh|
      hsh[str] = session[str]
    end
    params.permit(:name, :email, :phone, :address).merge(session_params)
  end

end
