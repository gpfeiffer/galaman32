require 'test_helper'

class PerformancesControllerTest < ActionController::TestCase
  setup do
    @performance = performances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:performances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create performance" do
    assert_difference('Performance.count') do
      post :create, :performance => @performance.attributes
    end

    assert_redirected_to performance_path(assigns(:performance))
  end

  test "should show performance" do
    get :show, :id => @performance.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @performance.to_param
    assert_response :success
  end

  test "should update performance" do
    put :update, :id => @performance.to_param, :performance => @performance.attributes
    assert_redirected_to performance_path(assigns(:performance))
  end

  test "should destroy performance" do
    assert_difference('Performance.count', -1) do
      delete :destroy, :id => @performance.to_param
    end

    assert_redirected_to performances_path
  end
end
