require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @assignment = assignments(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignments)
  end

  test "should get new" do
    get :new, :user_id => users(:two).to_param
    assert_response :success
  end

  test "should create assignment" do
    assert_difference('Assignment.count') do
      post :create, :assignment => @assignment.attributes
    end

    assert_redirected_to user_path(assigns(:assignment).user)
  end

  test "should show assignment" do
    get :show, :id => @assignment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @assignment.to_param
    assert_response :success
  end

  test "should update assignment" do
    put :update, :id => @assignment.to_param, :assignment => @assignment.attributes
    assert_redirected_to user_path(assigns(:assignment).user)
  end

  test "should destroy assignment" do
    assert_difference('Assignment.count', -1) do
      delete :destroy, :id => @assignment.to_param
    end

    assert_redirected_to user_path(assigns(:assignment).user)
  end
end
