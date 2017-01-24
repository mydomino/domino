class FatMealsController < ApplicationController
  def index
   
  end

  # GET /food-action-tracker/new
  def new
    @date = Date.today
  end

  # POST /food-action-tracker
  def create
    render json: {
      carbon_footprint: 100,
      status: 200
    }, status: 200
  end
end
