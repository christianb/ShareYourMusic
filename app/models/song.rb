class Song < ActiveRecord::Base
  validates :title, :presence => true  
  
  # each song is assigned to exactly one compact disk
  belongs_to :compact_disk
#  accepts_nested_attributes_for :compact_disk
  validates_presence_of :compact_disk
end
