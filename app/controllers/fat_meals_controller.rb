class FatMealsController < ApplicationController
  def index
   
  end

  # GET /food-action-tracker/
  # call this edit?
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

  # GET /food-action-tracker/edit
  def edit
    #todo check if meal_day exists for day by users timezone
    date = Date.today
    meal_day = MealDay.find_by(user: current_user, date: date)
    @fat_day = {
      meal_day: meal_day,
      meals: meal_day ? meal_day.meals : newMeals(meal_day),
      date: date,
      food_types: FoodType.all
    }
  end
  # food-action-tracker/:date

  # POST /food-action-tracker
  def create
    # Create MealDay record
    meal_day =  MealDay.create(
                  user: current_user,
                  date: Date.today
                )

    meals = JSON.parse(params[:meals])
    byebug
    meals.each do |meal|
      properties = meal[1];
      foods = properties["foods"]
      meal = Meal.create(
        size: properties['size'],
        meal_type: MealType.find(properties['id']),
        meal_day: meal_day
      )

      foods.each do |food|
        properties = food[1]
        Food.create(
          meal: meal,
          food_type: FoodType.find(properties['id'])
        )
      end
    end

    carbon_footprint = calculate_carbon_footprint
    meal_day.update(carbon_footprint: carbon_footprint)
    render json: {
      carbon_footprint: carbon_footprint,
      status: 200
    }, status: 200
  end

  # PUT /food-action-tracker/
  def update

  end

  private

  # /calculate_carbon_footprint

  def calculate_carbon_footprint
    100
  end

  def newMeals(meal_day)
    [
      {
        size: 0,
        name: MealType.breakfast.first.name
      },
      {
        size: 1,
        name: MealType.lunch.first.name
      },
      {
        size: 2,
        name: MealType.dinner.first.name
      }
    ]
        
  end
end
