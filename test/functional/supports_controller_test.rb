require 'test_helper'

class SupportsControllerTest < ActionController::TestCase
  setup do
    @support = supports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create support" do
    assert_difference('Support.count') do
      post :create, :support => @support.attributes
    end

    assert_redirected_to support_path(assigns(:support))
  end

  test "should show support" do
    get :show, :id => @support.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @support.to_param
    assert_response :success
  end

  test "should update support" do
    put :update, :id => @support.to_param, :support => @support.attributes
    assert_redirected_to support_path(assigns(:support))
  end

  test "should destroy support" do
    assert_difference('Support.count', -1) do
      delete :destroy, :id => @support.to_param
    end

    assert_redirected_to supports_path
  end
end
