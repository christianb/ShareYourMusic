require 'test_helper'

class CompactDiskTest < ActiveSupport::TestCase
  # set up test data for table user
  fixtures :compact_disks, :users
  
  def setup
    @disk = compact_disks(:beatsteaks)
  end
  
  def teardowns
    @disk = nil
  end
  
  test "cd attributes must not be empty" do
     cd = CompactDisk.new
     assert cd.invalid?
     assert cd.errors[:title].any?
     assert cd.errors[:artist].any?
     assert cd.errors[:genre].any?
  end
  
  test "user_id must exist to create new compact_disk" do
    disk = CompactDisk.new(:title => "test",
                           :artist => "bla",
                           :genre => "nichts")
    assert !disk.save, "should not save because user_id has not been set"
    
    @disk.user_id = 0
    assert @disk.save, "should save compact disk due user_id exist"
    
    @disk.user_id = 42
    assert !@disk.save, "should not save compact disk due user_id does not exist"
    
    
  end
  
end
