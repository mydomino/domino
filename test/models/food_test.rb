require "test_helper"

class FoodTest < ActiveSupport::TestCase


  test "Food can be saved with all required parameters" do

    @user = users(:User_1)

    @meal_day = MealDay.create(user: @user, 
    	date: Time.now, 
    	carbon_footprint: 35
    )

    @meal_type = MealType.create(caloric_budget: 60, 
    	name: 'breakfast'  
    	#name: MealType.breakfast        
    )

    @meal = Meal.create(size: Meal.small, 
    	meal_day:  @meal_day, 
    	meal_type: @meal_type
    )

    @food_type = FoodType.create(category: 'fruits', 
    	carbon_footprint: 32.5, 
    	icon: "fruits.png", 
    	name: "fruits"
    )

    food = Food.create(portion: 38, food_type: @food_type, meal: @meal)
    assert food.valid?, 'The food was not valid when all parameters were supplied' 
    
  end


  test "Food can not be saved without all required parameters" do

    food = Food.create(portion: 23)
    assert_not food.valid?, 'The food was not valid when missing required parameters.' 
    
  end


end
