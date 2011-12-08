class CompactDisk < ActiveRecord::Base
  validates :title, :artist, :genre, :presence => true
    
  # each compact disk is assigned to exactly one 
  belongs_to :user
  validates_presence_of :user
    
  has_many :songs
    
  has_attached_file :photo, :styles => { :normal => "150x150>", :small => "70x70>" },
                    :url  => "/system/covers/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/covers/:id/:style/:basename.:extension",
                    :default_url => "/assets/cd_default.png"
                      
  #validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  has_attached_file :audio,
                    :url => "/system/audios/:id/:basename.:extension",
                    :path => ":rails_root/public/system/audios/:id/:basename.:extension"

  attr_accessor :audio_file_name
  attr_accessor :audio_content_type
  attr_accessor :audio_file_size
end
