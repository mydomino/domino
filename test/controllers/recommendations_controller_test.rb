require 'test_helper'

class RecommendationsControllerTest < ActionController::TestCase
  setup do
    @recommendation = recommendations(:Recommendation_1)
    @user = users :User_1                                                                                   
    sign_in @user  
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  

  test "should destroy recommendation" do
    assert_difference('Recommendation.count', -1) do
      delete :destroy, id: @recommendation
    end

    assert_response :redirect
  end
end
