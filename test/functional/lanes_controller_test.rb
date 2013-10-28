require 'test_helper'

class LanesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get :index, :event_id => events(:one).to_param
    assert_response :success
  end

end
