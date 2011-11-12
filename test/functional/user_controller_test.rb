require 'test_helper'

class UserControllerTest < ActionController::TestCase
  #fixtures :roles, :users
  
  test "should get show" do
    get(:show, {'id' => "1"})
    assert_response :success
    assert_not_nil assigns(:user)
  end
end
