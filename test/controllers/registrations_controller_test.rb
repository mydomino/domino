require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  setup do
    
    @user = users :User_1                                                                                   
    sign_in @user  
  end

  
  # test "should get new" do
  #   get :new, params: { email: 'mel@mydomino.com'}
  #   assert_response :success
  # end
# 
# 
  # test "should create registration" do
  #   assert_difference('Registration.count') do
  #     post :create, registration: { email: 'mel@mydomino.com' }
  #   end
# 
  #   assert_response :redirect
  # end

  

end
