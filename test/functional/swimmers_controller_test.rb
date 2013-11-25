require 'test_helper'

class SwimmersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @swimmer = swimmers(:one)
    @attrs = { 
      :birthday => @swimmer.birthday, 
      :club_id => @swimmer.club_id, 
      :first => "First", 
      :gender => "f", 
      :last => "Last", 
      :number => "12345678" 
    }
    @other = swimmers(:two)
    @user = users(:one)
    sign_in @user
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
      post :create, :swimmer => @attrs
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
    put :update, :id => @swimmer.to_param, :swimmer => @attrs
    assert_redirected_to club_path(assigns(:swimmer).club)
  end

  test "should destroy swimmer" do
    assert_difference('Swimmer.count', -1) do
      delete :destroy, :id => @swimmer.to_param
    end

    assert_redirected_to club_path(assigns(:swimmer).club)
  end
end
