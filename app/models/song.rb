class Song < ActiveRecord::Base
  validates :title, :presence => true 
  # each song is assigned to exactly one compact disk
  #attr_accessible :title, :compact_disk_id, :songs_attributes
  belongs_to :compact_disk
  validates_presence_of :compact_disk
end
