require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  def setup
  end
  
  def teardown
  end
  
  test "role name must exist" do
    role = Role.new
    assert !role.save, "should not be saved due role name is empty"
  end
  
  test "role must unique" do
    role = Role.new(:role => "system")
    assert role.save, "should be saved due role does not exist"
    
    role = Role.new(:role => "system")
    assert !role.save, "should not be saved due role does exist"
  end
end
