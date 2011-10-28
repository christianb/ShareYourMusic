class CompactDisk < ActiveRecord::Base
    validates :title, :artist, :genre, :presence => true
end
