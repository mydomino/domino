require "test_helper"

class MealTest < ActiveSupport::TestCase
  def meal

    # use fixture data from fixture files
  	meal_day = meal_days(:meal_day_one)
  	meal_type = meal_types(:lunch)

    @meal ||= Meal.new(size: 'medium', meal_day: meal_day, meal_type: meal_type)
  end

  def test_valid
    assert meal.valid?
  end
end
