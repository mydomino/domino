require 'test_helper'

class PointsControllerTest < ActionController::TestCase
  test "should get add_watch_ttc_moive_points" do
    get :add_watch_ttc_moive_points
    assert_response :success
  end

end
