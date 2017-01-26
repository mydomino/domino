class FatMealsController < ApplicationController
  def index
   
  end

  # GET /food-action-tracker/new
  def new
    @date = Date.today
    @meal_types = MealType.all
    @food_types = FoodType.all

    # put server on PST (for logging)
    # translate to local time zone
    # Time in db should be UTC
  end

  # GET /food-action-tracker/:year/:month/:day
  def show
  end

  # POST /food-action-tracker
  def create
    # Create MealDay record
    meal_day = Meal.new(
                  user: current_user,
                  date: Date.today,
                  carbon_footprint: calculate_carbon_footprint
                )
    byebug
      # meal_day.meals.build()
    # Save users meal tracking
    render json: {
      carbon_footprint: 100,
      status: 200
    }, status: 200
  end

  private

  # /calculate_carbon_footprint

  def calculate_carbon_footprint
    100
  end
end
