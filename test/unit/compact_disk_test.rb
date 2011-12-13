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
  
  test "search compact_disk" do
    array = CompactDiskController.search("Bea")
    assert array.count == 1, "should contain exactly one CD"
    assert array[0].artist == "Beatsteaks", "Artist should be Beatsteaks"
    
    array = CompactDiskController.search("Li")
    assert array.count == 2, "should contain exactly two CD's"
    array.each do |t|
      assert t.artist == "Linkin Park", "Artist should be Linkin Park"
    end
    
    array = CompactDiskController.search("A Thous")
    assert array.count == 1, "should contain exactly one CD"
    assert array[0].artist == "Linkin Park", "Artist should be Linkin Park"
    assert array[0].title == "A Thousand Suns", "Title should be A Thousand Suns"
    
    array = CompactDiskController.search("rock")
    assert array.count == 2, "should contain exactly two CD's"

    array = CompactDiskController.search("20")
    assert array.count == 2, "should contain exactly two CD's"
    
    array = CompactDiskController.search("19")
    assert array.count == 1, "should contain exactly one CD"
    assert array[0].artist == "Beatsteaks", "Artist should be Beatsteaks"
    
  end
  
  test "release year" do
    @disk.year = 1952
    assert @disk.save, "should be saved"
    
    @disk.year = 1910
    assert !@disk.save, "should not be saved, due release date is out of range"
    
    @disk.year = Time.now.year+2
    assert !@disk.save, "should not be saved, due release date is in future"
                     
  end
end
