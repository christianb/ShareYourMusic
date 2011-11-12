require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "the truth" do
    get :index
    assert_response :success
  end
end
