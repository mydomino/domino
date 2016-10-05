require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:Product_1)
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

  test "should not create product" do
    assert_difference('Product.count', 0) do
      post :create, product: { name: 'ABC'  }
    end

    assert_response :success
  end

  # need to resolve pundit auth error - Yong
  #test "should show product" do
  #  get :show, id: @product
  #  assert_response :success
  #end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    patch :update, id: @product, product: { name: 'ABC' }
    #assert_redirected_to product_path(assigns(:product))
    assert_redirected_to products_path
  end


  # need to resolve pundit auth error - Yong
  # test "should destroy product" do
  #   assert_difference('Product.count', -1) do
  #     delete :destroy, id: @product
  #   end
# 
  #   assert_redirected_to products_path
  # end
end
