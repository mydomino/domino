require "test_helper"

class MealDayTest < ActiveSupport::TestCase
  def meal_day

  	@user = users(:User_1)

    @meal_day ||= MealDay.new(user: @user, 
    	date: Time.now, 
    	carbon_footprint: 35
    )
  end

  def test_valid
    assert meal_day.valid?
  end
end
