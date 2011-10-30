require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  fixtures :users
  
  def setup
    @user = users(:peter)
  end
  
  def teardowns
    @user = nil
  end
  
  test "user id's must exist to create new transaction" do    
    transaction = Transaction.new(:provider_id => 0,
                                  :receiver_id => 0)
    assert !transaction.save, "should not be saved due same user id"
    
    transaction.provider_id = 1
    assert transaction.save, "should be saved du both user id's exist"
    
    transaction = Transaction.new(:provider_id => 0,
                                  :receiver_id => 2)
    assert !transaction.save, "should not be saved du user id 2 does not exist"
    
    transaction = Transaction.new(:provider_id => 2,
                                  :receiver_id => 0)
    assert !transaction.save, "should not be saved du user id 2 does not exist"
    
  end
end
