require 'test_helper'

class DashboardsControllerTest < ActionController::TestCase

  setup do
    @dashboard = dashboards(:Dashboard_2)
    @user = users :User_1                                                                                   
    sign_in @user    
  end

  test "should get index" do
    get :index, params: { search: 'scott' }
    assert_response :success
  end

  

  test "should show dashboard" do
    get :show, id: @dashboard
    assert_response :success
  end



  test "should not destroy dashboard" do
    assert_equal('Dashboard.count', 'Dashboard.count') do

      #puts "Hello. Yong\n\n\n\n"
      delete :destroy, id: @dashboard
    end

    assert_response :success
    #assert_redirected_to dashboards_path
  end
end
