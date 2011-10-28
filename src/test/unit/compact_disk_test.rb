require 'test_helper'

class CompactDiskTest < ActiveSupport::TestCase
  test "cd attributes must not be empty" do
     cd = CompactDisk.new
     assert cd.invalid?
     assert cd.errors[:title].any?
     assert cd.errors[:artist].any?
     assert cd.errors[:genre].any?
  end
end
