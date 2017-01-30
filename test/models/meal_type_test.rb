require "test_helper"

class MealTypeTest < ActiveSupport::TestCase
  def meal_type

  	# load fixture data from fixture files because meal_typehas to be unique in the database
  	# the fixture data is created in the test database during test init 
  	@meal_type = meal_types(:dinner)

    @meal_type ||= MealType.new(caloric_budget: 35, name: 'dinner')
  end

  def test_valid

  	# note: this failed because it is not unique in the database
    assert meal_type.valid?
    
  end


end
