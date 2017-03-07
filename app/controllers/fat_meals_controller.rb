class FatMealsController < ApplicationController
  before_action :authenticate_user!
  # before_action :fat_graph_params, only: [:create, :update]
  include FatCompetition
 
  # GET /food-action-tracker
  # GET /food-action-tracker/:year/:month/:day
  # Purpose: Display the FAT interface for a given date
  #  If no date params are provided, the interface will
  #  render for the current date based on users timezone
  def edit
    time_zone_name = Time.zone.name
    time_now = Time.now.in_time_zone(time_zone_name)

    @today = Date.new(time_now.year, time_now.month, time_now.day)

    # Fat logging allowed only back to monday of current week
    @active_days = @today.cwday
    @lower_date_bounds = @today - @active_days + 1

    if params[:year].present?
      year = params[:year].to_i
      month = params[:month].to_i
      day = params[:day].to_i

      date = Date.new(year, month, day)
      # check date is within bounds
      # check lower bounds
      if(date < @lower_date_bounds)
        date = @lower_date_bounds
      #check upper bounds 
      elsif(date > @today)
        date = @today
      end
      @date_str = (@today - 1 == date) ? 'Yesterday' : ( (date == @today) ? 'Today' : date.strftime("%a") )
    else
      # Set FAT date based on user timezone
      # This is made possible by the browser-timezone-rails gem
      # Remove time data
      date = @today
      @date_str = "Today"
    end

    @prev_date = date - 1.day
    @next_date = date + 1.day

    meal_day = MealDay.includes(:foods).find_by(user: current_user, date: date)
    # Days after today up to Sunday
    days_left = 7 - @today.cwday
    fat_graph_date = @today - @active_days + 1
    @cf = []

    @active_days.times do
      meal_day_g = MealDay.find_by(date: fat_graph_date, user: current_user)
      cf = meal_day_g ? meal_day_g.carbon_footprint : nil
      points = meal_day_g ? (meal_day_g.points || 0) : 0
      @cf << {cf: cf, pts: points || 0, path: fat_graph_date.to_s.split("-").join("/")}
      fat_graph_date += 1.day
    end

    days_left.times do 
      @cf << {cf: "future", pts: "future"}
    end

    @fat_day = {
      meal_day: meal_day || MealDay.new,
      foods: meal_day ? meal_day.foods.map { |f| [f.food_type_id, f] }.to_h : {},
      date: date,
      food_types: FoodType.all,
      cf: @cf
    }
  end

  # POST /food-action-tracker
  # Create FAT resources for the date provided in params.
  def create
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

    fat_graph_params

    if params[:commit] == "didnt-eat"
      render json: {
        status: 200
      }
    else
      render json: {
        carbon_footprint: meal_day.carbon_footprint,
        foods: meal_day.foods.map { |f| [f.food_type_id, f] }.to_h,
        meal_day: meal_day,
        cf: @cf,
        status: 200
      }, status: 200
    end
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

    fat_graph_params

    if params[:commit] == "didnt-eat"
      render json: {
        status: 200
      }
    else
      render json: {
        carbon_footprint: meal_day.carbon_footprint,
        foods: meal_day.foods.map { |f| [f.food_type_id, f] }.to_h,
        meal_day: meal_day,
        cf: @cf,
        status: 200
      }, status: 200
    end
  end

  private 

  def fat_graph_params
    time_zone_name = Time.zone.name
    time_now = Time.now.in_time_zone(time_zone_name)

    @today = Date.new(time_now.year, time_now.month, time_now.day)
    @active_days = @today.cwday

    days_left = 7 - @today.cwday
    fat_graph_date = @today - @active_days + 1
    @cf = []

    @active_days.times do
      meal_day_g = MealDay.find_by(date: fat_graph_date, user: current_user)
      cf = meal_day_g ? meal_day_g.carbon_footprint : nil
      points = meal_day_g ? (meal_day_g.points || 0) : 0
      @cf << {cf: cf, pts: points || 0, path: fat_graph_date.to_s.split("-").join("/")}
      fat_graph_date += 1.day
    end

    days_left.times do 
      @cf << {cf: "future", pts: "future"}
    end
  end
end
