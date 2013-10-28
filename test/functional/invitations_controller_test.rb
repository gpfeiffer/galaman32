require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @invitation = invitations(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index, :club_id => clubs(:one)
    assert_response :success
    assert_not_nil assigns(:invitations)
  end

  test "should get new" do
    get :new, :competition_id => competitions(:two).to_param
    assert_response :success
  end

  test "should create invitation" do
    assert_difference('Invitation.count') do
      post :create, :invitation => @invitation.attributes
    end

    assert_redirected_to competition_path(assigns(:invitation).competition)
  end

  test "should show invitation" do
    get :show, :id => @invitation.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @invitation.to_param, :competition_id => @competition.to_param
    assert_response :success
  end

  test "should update invitation" do
    put :update, :id => @invitation.to_param, :invitation => @invitation.attributes.merge({ :swimmer_ids => @invitation.swimmer_ids.map(&:to_param) })
    assert_redirected_to invitation_path(assigns(:invitation))
  end

  test "should destroy invitation" do
    assert_difference('Invitation.count', -1) do
      delete :destroy, :id => @invitation.to_param
    end

    assert_redirected_to competition_path(assigns(:invitation).competition)
  end
end
