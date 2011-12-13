require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  fixtures :users, :compact_disks
  
  def setup
  end
  
  def teardowns
  end
  
  test "user id's and disk ids' must exist to create new transaction" do    
    transaction = Transaction.new(:provider_id => 0,
                                  :receiver_id => 0,
                                  :provider_disk_id => 0,
                                  :receiver_disk_id => 1)
    assert !transaction.save, "should not be saved due same user id"
    
    transaction = Transaction.new(:provider_id => 1,
                                  :receiver_id => 0,
                                  :provider_disk_id => 0,
                                  :receiver_disk_id => 0)
    assert !transaction.save, "should not be saved due same disk id"
    
    transaction = Transaction.new(:provider_id => 1,
                                  :receiver_id => 0,
                                  :provider_disk_id => 1,
                                  :receiver_disk_id => 0)
    assert transaction.save, "should be saved du both user id's and disk_id's exist"
    
    
    transaction = Transaction.new(:provider_id => 0,
                                  :receiver_id => 99,
                                  :provider_disk_id => 1,
                                  :receiver_disk_id => 0)
    assert !transaction.save, "should not be saved du receiver_user_id 99 does not exist"
    
    transaction = Transaction.new(:provider_id => 99,
                                  :receiver_id => 0,
                                  :provider_disk_id => 1,
                                  :receiver_disk_id => 0)
    assert !transaction.save, "should not be saved du provider_user_id 99 does not exist"
    
    transaction = Transaction.new(:provider_id => 1,
                                  :receiver_id => 0,
                                  :provider_disk_id => 99,
                                  :receiver_disk_id => 0)
    assert !transaction.save, "should not be saved because provider_disk_id 99 does not exist"
    
    transaction = Transaction.new(:provider_id => 1,
                                  :receiver_id => 0,
                                  :provider_disk_id => 0,
                                  :receiver_disk_id => 99)
    assert !transaction.save, "should not be saved because receiver_disk_id 99 does not exist"
    
  end
end
