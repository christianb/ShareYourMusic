require 'test_helper'

class SongTest < ActiveSupport::TestCase
  test "song attributes must not be empty" do
     song = Song.new
     assert song.invalid?
     assert song.errors[:title].any?
  end
end
