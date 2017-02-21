require 'test_helper'
require File.expand_path("../../../lib/fat_competition", __FILE__)


class PointsLogTest < ActiveSupport::TestCase
  include FatCompetition

  def setup
    @user = users(:User_1)

    @points_log = PointsLog.new(point_date: Time.zone.today, 
      point_type: PointsLog::SIGN_IN_EACH_DAY, 
      desc: PointsLog::SIGN_IN_EACH_DAY, 
      point: PointsLog::SIGN_IN_EACH_DAY_POINTS, 
      user: @user,    
      )

    @points_log.save!

  end


  test "valid points_log" do

    assert @points_log.valid?
  end


  test "invalid without date" do
    
    @points_log.point_date = nil

    assert_not @points_log.valid? "it should not be valid."
  end

  test "invalid without a user" do
    
    @points_log.user = nil

    assert_not @points_log.valid? "it should not be valid."
  end


  test "invalid without a point type" do
    
    @points_log.point_type = nil

    assert_not @points_log.valid? "it should not be valid."
  end


  test "PointsLog can be saved with all required parameters" do

    #user = users(:User_1)

    p_log = PointsLog.find_or_create_by!(user: @user,
  		point_type: FatCompetition::TRACK_FOOD_LOG, point_date: Time.zone.today) do |pl| 

    	pl.user = @user
    	pl.point_type = FatCompetition::TRACK_FOOD_LOG
    	pl.point_date = Time.zone.today
    	pl.desc = "Sign in each day earns you point."
    	pl.point = FatCompetition::TRACK_FOOD_LOG_POINTS

    end

    assert p_log.valid?, 'The p_log was not valid when all parameters were supplied' 

    assert p_log.save!, 'The p_log was not saved properly.'
    
  end

  test "can add point with class function single time" do

  	p_log = PointsLog.add_point(users(:User_1), PointsLog::CLICK_ARTICLE_LINK, "Log food TAT each day", 
      PointsLog::CLICK_ARTICLE_LINK_POINTS, Time.zone.today)


    assert_not_nil p_log, 'The p_log was not added properly to the database.'
  	
  end

  test "can add point with class function many times" do

  	p_log = PointsLog.add_point(users(:User_1), "UNLIMIT", "I did good!", 5, Time.zone.today)
  	
    assert_not_nil p_log, 'The p_log was not added properly to the database.'
  	
  end

  test "update a point log" do

    old_points_log = @points_log

    assert PointsLog.update_point(old_points_log.user, old_points_log.point_type, 
      old_points_log.desc, old_points_log.point+10, old_points_log.point_date), "The p_log was not updated properly to the database."

  end

  test "remove a point log" do

    # ensure the points_log was in the database before removal
    assert PointsLog.has_point?(@points_log.user, @points_log.point_type, @points_log.point_date), "The p_log should be in the database."
    assert PointsLog.remove_point(@points_log.user, @points_log.point_type, @points_log.point_date)
    assert_not PointsLog.has_point?(@points_log.user, @points_log.point_type, @points_log.point_date), "The p_log should not be in the database."
    
  end


  test "verify a point log exist in the database" do

    assert PointsLog.has_point?(@points_log.user, @points_log.point_type, @points_log.point_date), "The p_log should be in the database."
    
  end


end
