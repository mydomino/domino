class SessionsController < ApplicationController

  def calculate
    @savings = SavingsLocation.find(params[:id])
    # TODO: Store location in User model so if they register we'll have some data
    # TODO: Write function to check if session already exists, and if not create a new one.
    #   Since multiple functions could potentially create a session object.
    # @session = Session.new(city/state/zip attribute hash from @savings)
    render :calculate
  end

  def typeahead
    render json: SavingsLocation.select("id, city, state")
                     .where('city ilike ?', "#{params[:query]}%")
  end

  private

  def session_params
    params.permit(:id)
  end
end
