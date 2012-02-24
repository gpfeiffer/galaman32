require 'test_helper'

class AimsControllerTest < ActionController::TestCase
  setup do
    @aim = aims(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aims)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aim" do
    assert_difference('Aim.count') do
      post :create, :aim => @aim.attributes
    end

    assert_redirected_to aim_path(assigns(:aim))
  end

  test "should show aim" do
    get :show, :id => @aim.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @aim.to_param
    assert_response :success
  end

  test "should update aim" do
    put :update, :id => @aim.to_param, :aim => @aim.attributes
    assert_redirected_to aim_path(assigns(:aim))
  end

  test "should destroy aim" do
    assert_difference('Aim.count', -1) do
      delete :destroy, :id => @aim.to_param
    end

    assert_redirected_to aims_path
  end
end
