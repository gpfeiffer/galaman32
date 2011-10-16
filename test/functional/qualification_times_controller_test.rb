require 'test_helper'

class QualificationTimesControllerTest < ActionController::TestCase
  setup do
    @qualification_time = qualification_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:qualification_times)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create qualification_time" do
    assert_difference('QualificationTime.count') do
      post :create, :qualification_time => @qualification_time.attributes
    end

    assert_redirected_to qualification_time_path(assigns(:qualification_time))
  end

  test "should show qualification_time" do
    get :show, :id => @qualification_time.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @qualification_time.to_param
    assert_response :success
  end

  test "should update qualification_time" do
    put :update, :id => @qualification_time.to_param, :qualification_time => @qualification_time.attributes
    assert_redirected_to qualification_time_path(assigns(:qualification_time))
  end

  test "should destroy qualification_time" do
    assert_difference('QualificationTime.count', -1) do
      delete :destroy, :id => @qualification_time.to_param
    end

    assert_redirected_to qualification_times_path
  end
end
