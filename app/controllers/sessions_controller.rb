class SessionsController < ApplicationController
  caches_page :about

  def index
    env['HTTP_X_REAL_IP'] = '184.23.234.242' if Rails.env.development?
    session[:ip] = request.remote_ip
    session[:referer] ||= request.referer
    session[:browser] = request.user_agent
    session[:start_time] = Time.now
    session[:campaign] = request['utm_campaign']
    session[:city] = request.location.city

    puts "*****1 #{request.remote_ip}"
    puts "*****2 #{session[:ip]}"
    puts "*****4 #{request.location.city}"
    puts "*****5 #{Geocoder.search(request.remote_ip, ip_address: true).first}"
    puts "*****6 #{request.location}"
    puts "*****7 #{request.location.methods(false)}"
    puts "*****8 #{request.location.latitude}"

    session[:state] = request.location.state_code
    session[:zipcode] = request.location.postal_code
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
