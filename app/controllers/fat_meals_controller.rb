class FatMealsController < ApplicationController
  before_action :authenticate_user!
  
  # GET /food-action-tracker
  # GET /food-action-tracker/:year/:month/:day
  # Purpose: Display the FAT interface for a given date
  #  If no date params are provided, the interface will
  #  render for the current date based on users timezone
  def edit
    time_zone_name = Time.zone.name

    if params[:year].present?
      year = params[:year].to_i
      month = params[:month].to_i
      day = params[:day].to_i

      time = Time.new(year, month, day)
    else
      # Set FAT date based on user timezone
      # This is made possible by the browser-timezone-rails gem
      time = Time.now
    end
    fat_date = Date.new(time.year, time.month, time.day)
    
    @prev_date = time - 1.day
    @next_date = time + 1.day
    @current_date = Date.today
    
    meal_day = MealDay.includes(meals: [:meal_type, :foods]).find_by(user: current_user, date: time.in_time_zone(time_zone_name))

    @fat_day = {
      meal_day: meal_day,
      meals: meal_day ? meal_day.meals.order(:meal_type_id).as_json(:include => [:meal_type, :foods]) : new_meals,
      date: fat_date,
      meal_type: MealType.all,
      food_types: FoodType.all
    }
  end

  # POST /food-action-tracker
  # Create FAT resources for the date provided in params.
  def create
    date_param = params[:fat_day][:date]
    meals = params[:fat_day][:meals]

    meal_day =  MealDay.create(
                  user: current_user,
                  date: date_param
                )

    meals.each do |key, fat_meal|
      meal = Meal.create(
        size: fat_meal[:size],
        meal_type: MealType.find(fat_meal[:meal_type][:id]),
        meal_day: meal_day
      )

      if fat_meal[:foods]
        fat_meal[:foods].each do |key, value|
          food = Food.create(
            food_type_id: value[:food_type_id],
            meal: meal
          )
        end
      end
    end

    meal_day.update(carbon_footprint: calculate_carbon_footprint)

    render json: {
      carbon_footprint: meal_day.carbon_footprint,
      meals: meal_day.meals.order(:meal_type_id).as_json(:include => [:meal_type, :foods]),
      meal_day: meal_day,
      status: 200
    }, status: 200
  end

  # PATCH /food-action-tracker/
  # Update FAT resources for date provided in params
  def update
    meal_day_id = params[:meal_day][:id].to_i
    meal_day = MealDay.find(meal_day_id)
    meals = params[:fat_day][:meals]

    meals.each do |fat_meal|
      data = fat_meal[1]
      foods = data[:foods]
      meal = Meal.find(data[:id])
      meal.update(size: data[:size])
      meal.foods.destroy_all

      if foods 
        foods.each do |key, value|
          food = Food.create(
            food_type_id: value[:food_type_id],
            meal: meal
          )
        end
      end
    end

    render json: {
      carbon_footprint: 100,
      meals: meal_day ? JSON.parse(meal_day.meals.order(:meal_type_id).to_json(:include => [:meal_type, :foods])) : new_meals,
      meal_day: meal_day,
      status: 200
    }, status: 200
  end

  private

  # /calculate_carbon_footprint/
  def calculate_carbon_footprint
    100
  end

  # /new_meals/
  # Purpose: For new FAT views, pass default meal objects to React
  def new_meals
    [
      {
        meal_type_id: 1,
        size: "medium",
        foods: [],
        meal_type: {
          id: 1,
          name: "breakfast"
        }
      },
      {
        meal_type_id: 2,
        size: "medium",
        foods: [],
        meal_type: {
          id: 2,
          name: "lunch"
        }
      },
      {
        meal_type_id: 3,
        size: "medium",
        foods: [],
        meal_type: {
          id: 3,
          name: "dinner"
        }
      }
    ]
  end
end
