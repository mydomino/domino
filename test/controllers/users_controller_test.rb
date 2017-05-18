require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get beta_index" do
    get :beta_index
    assert_response :success
  end

end
