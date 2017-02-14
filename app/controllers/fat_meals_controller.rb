class FatMealsController < ApplicationController
  before_action :authenticate_user!
  include FatCompetition
  # GET /food-action-tracker
  # GET /food-action-tracker/:year/:month/:day
  # Purpose: Display the FAT interface for a given date
  #  If no date params are provided, the interface will
  #  render for the current date based on users timezone
  def edit
    time_zone_name = Time.zone.name
    time_now = Time.now.in_time_zone(time_zone_name)
    @current_date = Date.new(time_now.year, time_now.month, time_now.day)

    if params[:year].present?
      year = params[:year].to_i
      month = params[:month].to_i
      day = params[:day].to_i

      date = Date.new(year, month, day)
    else
      # Set FAT date based on user timezone
      # This is made possible by the browser-timezone-rails gem
      # Remove time data
      date = Date.new(time_now.year, time_now.month, time_now.day)
    end
    # fat_date = Date.new(time.year, time.month, time.day)

    @prev_date = date - 1.day
    @next_date = date + 1.day

    meal_day = MealDay.includes(:foods).find_by(user: current_user, date: date)

    @fat_day = {
      meal_day: meal_day || MealDay.new,
      foods: meal_day ? meal_day.foods.map { |f| [f.food_type_id, f] }.to_h : {},
      date: date,
      food_types: FoodType.all
    }
  end

  # POST /food-action-tracker
  # Create FAT resources for the date provided in params.
  def create
    # PointLog.award_point(user, 'FAT_TRACK')
    date_param = params[:fat_day][:date]
    foods = params[:fat_day][:foods]
    meal_day =  MealDay.create(
                  user: current_user,
                  date: date_param
                )
    if foods
      foods.each do |key, value|
        meal_day.foods << Food.create(food_type_id: key.to_i, size: value[:size].to_f)
      end
    end
    meal_day.calculate_cf

    FatCompetition::award_points(meal_day)

    render json: {
      carbon_footprint: meal_day.carbon_footprint,
      foods: meal_day.foods.map { |f| [f.food_type_id, f] }.to_h,
      meal_day: meal_day,
      status: 200
    }, status: 200
  end

  # PATCH /food-action-tracker/
  # Update FAT resources for date provided in params
  def update
    meal_day_id = params[:fat_day][:meal_day][:id].to_i
    foods = params[:fat_day][:foods]

    meal_day = MealDay.find(meal_day_id)

    meal_day.foods.destroy_all

    if foods 
      foods.each do |key, value|
        meal_day.foods << Food.create(food_type_id: key.to_i, size: value[:size].to_f)
      end
    end
    meal_day.calculate_cf

    FatCompetition::award_points(meal_day)

    render json: {
      carbon_footprint: meal_day.carbon_footprint,
      foods: meal_day.foods.map { |f| [f.food_type_id, f] }.to_h,
      meal_day: meal_day,
      status: 200
    }, status: 200
  end
end
