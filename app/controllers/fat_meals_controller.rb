class FatMealsController < ApplicationController
  include FatCompetition

  skip_before_filter  :verify_authenticity_token
  before_action :authenticate_user!
  before_action :set_date, only: [:edit, :create, :update]
 
  # GET /food
  # GET /food/:year/:month/:day
  # Purpose: Display the FAT interface for a given date
  #  If no date params are provided, the interface will
  #  render for the current date based on users timezone
  def edit
    meal_day = MealDay.includes(:foods).find_by(user: current_user, date: @date)
    
    @graph_params = get_graph_params
    
    @fat_day = {
      meal_day: meal_day || MealDay.new,
      foods: meal_day ? meal_day.foods.map { |f| [f.food_type_id, f] }.to_h : {},
      date: @date,
      food_types: FoodType.all,
      graph_params: @graph_params,
      prev_week: @prev_week
    }

    track_event "View Food", {"User": current_user.email}
  end

  # POST /food-action-tracker XmlHttpRequest
  # Create FAT resources for the date provided in params.
  def create
    food = nil
    foods = params[:fat_day][:foods]
    @meal_day =  MealDay.create(
                  user: current_user,
                  date: @date
                )
    if foods
      foods.each do |key, value|
        food = Food.create(food_type_id: key.to_i, size: value[:size].to_f)
        @meal_day.foods << food
      end
    end

    @meal_day.calculate_cf
    FatCompetition::award_points(@meal_day)
    
    food_type = 'None'
    size = 0
    unless food.nil? 
      food_type = food.food_type.category
      size = food.size
    end 
    track_event "Initiate Food tracking", { "User": current_user.email,
      "food_date": @meal_day.date,
      "food_type": food_type,
      "food_size": size }

    @graph_params = get_graph_params
    render_response
  end

  # PATCH /food-action-tracker/ XmlHttpRequest
  # Update FAT resources for date provided in params
  def update
    food = nil
    meal_day_id = params[:fat_day][:meal_day][:id].to_i
    foods = params[:fat_day][:foods]

    @meal_day = MealDay.find(meal_day_id)

    @meal_day.foods.destroy_all

    if foods 
      foods.each do |key, value|
        food = Food.create(food_type_id: key.to_i, size: value[:size].to_f)
        @meal_day.foods << food
      end
    end
    @meal_day.calculate_cf
    FatCompetition::award_points(@meal_day)

    food_type = 'None'
    size = 0
    unless food.nil? 
      food_type = food.food_type.category
      size = food.size
    end 
    track_event "Update Food", { "User": current_user.email,
      "food_date": @meal_day.date,
      "food_type": food_type,
      "food_size": size }
  
    @graph_params = get_graph_params
    render_response
  end

  private

  # /get_graph_params/
  # Purpose: Set FAT card timeline parameters
  def get_graph_params
    if(@today_datetime.monday? && @today_datetime.hour < 23 && @date < @today )
      @prev_week = true
      return fat_graph_params(@today-7, @prev_week)
    else
      @prev_week = false
      return fat_graph_params(@date)
    end
  end
  # /render_response/
  # Purpose: send response payload back to FAT react UI
  def render_response
     if params[:commit] == "didnt-eat"
      render json: {
        status: 200
      }
    else
      render json: {
        carbon_footprint: @meal_day.carbon_footprint,
        foods: @meal_day.foods.map { |f| [f.food_type_id, f] }.to_h,
        meal_day: @meal_day,
        graph_params: @graph_params,
        status: 200
      }, status: 200
    end
  end

  # /set_date/
  # Purpose: Set the date of the fat interface
  def set_date
    time_zone_name = Time.zone.name
    time_now = Time.now.in_time_zone(time_zone_name)
    @today = Date.new(time_now.year, time_now.month, time_now.day)
    @today_datetime = DateTime.new(time_now.year, time_now.month, time_now.day, time_now.hour)

    # Food logging only permitted back to Monday of current week
    # Unless its before 11pm on Monday of the current week
    # Then lower_date_bounds is Monday of the previous week
    if(time_now.monday? && time_now.hour < 23)
      @lower_date_bounds = @today - 7
    else
      @lower_date_bounds = @today - @today.cwday + 1
    end

    if params[:fat_day]
      @date = Date.strptime(params[:fat_day][:date], "%Y-%m-%d")
    elsif params[:year].present?
      year = params[:year].to_i
      month = params[:month].to_i
      day = params[:day].to_i

      @date = Date.new(year, month, day)
      
      # check date is within bounds
      # Lower bounds: M of current week
      # Upper bounds: Su of current week. Su is last day of week
      if(@date < @lower_date_bounds)
        @date = @lower_date_bounds
      #check upper bounds 
      elsif(@date > @today)
        @date = @today
      end
      @date_str = (@today - 1 == @date) ? 'Yesterday' : ( (@date == @today) ? 'Today' : @date.strftime("%A") )
    else
      @date = @today
      @date_str = "Today"
    end

    @prev_date = @date - 1
    @next_date = @date + 1
  end


  # /fat_graph_params/
  # Purpose: Create a data structure whose values are used to render fat graph
  def fat_graph_params(date, prev_week=false)
    if(prev_week)
      graph_params = {day_index: @date.cwday - 1, values: []}
      7.times do
        meal_day_g = MealDay.find_by(date: date, user: current_user)
        cf = meal_day_g ? meal_day_g.carbon_footprint : nil
        points = meal_day_g ? (meal_day_g.points || 0) : 0
        graph_params[:values] << {cf: cf, pts: points || 0, path: date.to_s.split("-").join("/")}
        date += 1.day
      end
    else
      @active_days = @today.cwday
      days_left = 7 - @today.cwday
      fat_graph_date = @today - @active_days + 1
      graph_params = {day_index: date.cwday - 1, values: []}

      @active_days.times do
        meal_day_g = MealDay.find_by(date: fat_graph_date, user: current_user)
        cf = meal_day_g ? meal_day_g.carbon_footprint : nil
        points = meal_day_g ? (meal_day_g.points || 0) : 0
        graph_params[:values] << {cf: cf, pts: points || 0, path: fat_graph_date.to_s.split("-").join("/")}
        fat_graph_date += 1.day
      end

      days_left.times do 
        graph_params[:values] << {cf: "future", pts: "future"}
      end
    end

    return graph_params
  end
end
