require "test_helper"

class FoodTypeTest < ActiveSupport::TestCase
  def food_type
    @food_type ||= FoodType.new(category: 'fruits', 
    	carbon_footprint: 32.5, 
    	icon: "fruits.png", 
    	name: "fruits"
    )

  end

  def test_valid
    assert food_type.valid?
  end
end
