require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  setup do
    @profile = profiles(:Profile_1)
    @user = users :User_1                                                                                   
    sign_in @user  
  end

  

  test "should not create profile" do
    assert_equal('Profile.count', 'Profile.count') do
      post :create, profile: { email: 'domino123@mydomino.com' }
    end

    assert_response :success
  end

  

  test "should update profile" do
    patch :update, id: @profile, profile: { email: 'mary.keli@gmail.com' }
    assert_response :success
  end

  
end
