class SessionsController < ApplicationController

  def index
    # TODO: Fix this hack.  Ip address should be retrieved/stored in session model.
    # It should use pre-configured data for development environment
    ip = request.remote_ip
    ip = '75.149.54.14' if ip == '127.0.0.1'
    @geolocation = GeoIp.geolocation(ip)


    # @test = ('maa'..'mzz').to_a
    # results = []
    # @test.each do |letters|
    #   @result = SavingsLocation.select("city").where("city ilike ?", letters + '%')
    #   results.push ({count: @result.length, letters: letters})
    # end
    # results.sort_by! { |hsh| hsh[:count] }.reverse!
    # hi = 0

  end

  def calculate
    @location = SavingsLocation.find_by_params(params)
    # TODO: Store location in Session model so if they register we'll have some data
    # TODO: Write function to check if session already exists, and if not create a new one.
    #   Since multiple functions could potentially create a session object.
    # @session = Session.new(city/state/zip attribute hash from @savings)
    render json: @location
  end

  def typeahead
    @location = SavingsLocation.find_city_info(params[:query])
    render json: @location
  end

end
