require "test_helper"

class FoodTest < ActiveSupport::TestCase


  test "Food can be saved with all required parameters" do

    @user = users(:User_1)

    @meal_day = MealDay.create(user: @user, 
    	date: Time.zone.now, 
    	carbon_footprint: 35
    )


    @food_type = FoodType.create(category: 'fruits', 
    	carbon_footprint: 32.5, 
    	icon: "fruits.png", 
    	name: "fruits"
    )

    food = Food.create(portion: 38, food_type: @food_type, meal_day: @meal_day)
    assert food.valid?, 'The food was not valid when all parameters were supplied' 
    
  end


  test "Food can not be saved without all required parameters" do

    food = Food.create(portion: 23)
    assert_not food.valid?, 'The food was not valid when missing required parameters.' 
    
  end


end
