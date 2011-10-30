require 'test_helper'

class SongTest < ActiveSupport::TestCase
  # set up test data for table user
  fixtures :compact_disks, :songs
  
  def setup
    @song = songs(:hello_joe)
  end
  
  def teardowns
    @song = nil
  end
  
  test "song attributes must not be empty" do
     song = Song.new
     assert song.invalid?
     assert song.errors[:title].any?
  end
  
  test "compact_disk id must exist to create new song" do    
    song = Song.new(:title => "Test",
                    :compact_disk_id => 0)
    assert song.save, "should save song due disk_id exist"
    
    song.compact_disk_id = 42
    assert !song.save, "should not be saved due compact_disk_id does not exist"
  end
end
