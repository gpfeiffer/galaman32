require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  setup do
    @entry = entries(:one)
    @entry[:mins] = 1
    @entry[:secs] = 1
    @entry[:centis] = 1
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
  end

  test "should get new" do
    get :new, :event_id => @entry.event.to_param, :registration_id => @entry.registration.to_param
    assert_response :success
  end

  test "should create entry" do
    assert_difference('Entry.count') do
      post :create, :entry => @entry.attributes
    end

    assert_redirected_to competition_path(assigns(:entry).event.competition, :club_id => @entry.swimmer.club_id)
  end

  test "should show entry" do
    get :show, :id => @entry.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @entry.to_param
    assert_response :success
  end

  test "should update entry" do
    put :update, :id => @entry.to_param, :entry => @entry.attributes
    assert_redirected_to competition_path(assigns(:entry).event.competition, :club_id => @entry.swimmer.club_id)
  end

  test "should destroy entry" do
    assert_difference('Entry.count', -1) do
      delete :destroy, :id => @entry.to_param
    end

    assert_redirected_to entries_path
  end
end
