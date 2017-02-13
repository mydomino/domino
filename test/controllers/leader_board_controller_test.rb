require 'test_helper'

class LeaderBoardControllerTest < ActionController::TestCase
  test "should get cfp_ranking" do
    get :cfp_ranking
    assert_response :success
  end

end
