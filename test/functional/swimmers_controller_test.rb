require 'test_helper'

class SwimmersControllerTest < ActionController::TestCase
  setup do
    @swimmer = swimmers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:swimmers)
  end

  test "should get new" do
    get :new, :club_id => @swimmer.club.to_param
    assert_response :success
  end

  test "should create swimmer" do
    assert_difference('Swimmer.count') do
      post :create, :swimmer => @swimmer.attributes
    end

    assert_redirected_to club_path(assigns(:swimmer).club)
  end

  test "should show swimmer" do
    get :show, :id => @swimmer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @swimmer.to_param
    assert_response :success
  end

  test "should update swimmer" do
    put :update, :id => @swimmer.to_param, :swimmer => @swimmer.attributes
    assert_redirected_to club_path(assigns(:swimmer).club)
  end

  test "should destroy swimmer" do
    assert_difference('Swimmer.count', -1) do
      delete :destroy, :id => @swimmer.to_param
    end

    assert_redirected_to swimmers_path
  end
end
