require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:Task_1)
    @user = users :User_1                                                                                   
    sign_in @user  
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { icon: 'energy' }
    end

    assert_redirected_to tasks_path
  end


  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { name: 'Solar Power' }
    assert_redirected_to tasks_path
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to tasks_path
  end
end
