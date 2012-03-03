require 'test_helper'

class RelaysControllerTest < ActionController::TestCase
  setup do
    @relay = relays(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:relays)
  end

  test "should get new" do
    get :new, :invitation_id => @relay.invitation.to_param
    assert_response :success
  end

  test "should create relay" do
    assert_difference('Relay.count') do
      post :create, :relay => @relay.attributes
    end

    assert_redirected_to invitation_path(assigns(:relay).invitation)
  end

  test "should show relay" do
    get :show, :id => @relay.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @relay.to_param
    assert_response :success
  end

  test "should update relay" do
    put :update, :id => @relay.to_param, :relay => @relay.attributes
    assert_redirected_to invitation_path(assigns(:relay).invitation)
  end

  test "should destroy relay" do
    assert_difference('Relay.count', -1) do
      delete :destroy, :id => @relay.to_param
    end

    assert_redirected_to invitation_path(assigns(:relay).invitation)
  end
end
