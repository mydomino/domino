class SessionsController < ApplicationController

  def calculate
    @location = SavingsLocation.find(params[:id])
    # TODO: Store location in User model so if they register we'll have some data
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
