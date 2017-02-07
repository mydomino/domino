require 'test_helper'

class PointsLogTest < ActiveSupport::TestCase
  

  test "PointsLog can be saved with all required parameters" do

    user = users(:User_1)

    p_log = PointsLog.find_or_create_by!(user: user,
  		point_type: "SIGN_IN_EACH_DAY", point_date: Time.zone.today) do |pl| 

    	pl.user = user
    	pl.point_type = "SIGN_IN_EACH_DAY"
    	pl.point_date = Time.zone.today
    	pl.desc = "Sign in each day earns you point."
    	pl.point =  10

    end

    assert p_log.valid?, 'The p_log was not valid when all parameters were supplied' 
    
  end

  test "can add point with class function single time" do

  	p_log = PointsLog.add_point(users(:User_1), "TAKE_FOOD_LOG", "Log food TAT each day", 5, Time.zone.today)
  	assert p_log.valid?
  	
  end

  test "can add point with class function many times" do

  	p_log = PointsLog.add_point(users(:User_1), "UNLIMIT", "I did good!", 5, Time.zone.today)
  	assert p_log.valid?
  	
  end

end
