require 'test_helper'

class DocketsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @docket = dockets(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index, :club_id => @docket.club.to_param, :invitation_id => @docket.invitation.to_param
    assert_response :success
    assert_not_nil assigns(:invitation)
  end

  # never used:
  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  test "should create docket" do
    assert_difference('Docket.count') do
      post :create, :docket => @docket.attributes
    end

    assert_redirected_to docket_path(assigns(:docket))
  end

  test "should show docket" do
    get :show, :id => @docket.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @docket.to_param
    assert_response :success
  end

  test "should update docket" do
    put :update, :id => @docket.to_param, :docket => @docket.attributes
    assert_redirected_to docket_path(assigns(:docket))
  end

  test "should destroy docket" do
    assert_difference('Docket.count', -1) do
      delete :destroy, :id => @docket.to_param
    end

    assert_redirected_to invitation_path(assigns(:docket).invitation)
  end
end
