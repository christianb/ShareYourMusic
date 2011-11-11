class CompactDisk < ActiveRecord::Base
    validates :title, :artist, :genre, :presence => true
    
    # each compact disk is assigned to exactly one user
    belongs_to :user
    validates_presence_of :user
    
    has_many :songs
end
