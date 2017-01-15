require 'test_helper'

class StrokesControllerTest < ActionController::TestCase
  setup do
    @stroke = strokes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:strokes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stroke" do
    assert_difference('Stroke.count') do
      post :create, stroke: { code: @stroke.code, name: @stroke.name, short: @stroke.short }
    end

    assert_redirected_to stroke_path(assigns(:stroke))
  end

  test "should show stroke" do
    get :show, id: @stroke
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stroke
    assert_response :success
  end

  test "should update stroke" do
    put :update, id: @stroke, stroke: { code: @stroke.code, name: @stroke.name, short: @stroke.short }
    assert_redirected_to stroke_path(assigns(:stroke))
  end

  test "should destroy stroke" do
    assert_difference('Stroke.count', -1) do
      delete :destroy, id: @stroke
    end

    assert_redirected_to strokes_path
  end
end
