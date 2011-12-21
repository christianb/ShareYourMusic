class DateOfReleaseValidator < ActiveModel::Validator
  def validate(record)
    if record.year == nil
      return
    end
    
    if record.year > Time.now.year
      record.errors[:base] << "Erscheinungsjahr darf nicht in der Zukunft liegen."
    end
    
    if !((record.year > (Time.now.year - 100)) && (record.year < Time.now.year))
      record.errors[:base] << "Erscheinungsjahr muss zwischen "+(Time.now.year-100).to_s+" und "+Time.now.year.to_s+ " liegen"
    end
  end
end

class CompactDisk < ActiveRecord::Base
  validates :title, :artist, :presence => true
    
  # each compact disk is assigned to exactly one 
  belongs_to :user
  validates_presence_of :user
    
  has_many :songs, :dependent => :destroy
  accepts_nested_attributes_for :songs
    
  has_attached_file :photo, :styles => { :normal => "150x150>", :small => "70x70>" },
                    :url  => "/system/covers/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/covers/:id/:style/:basename.:extension",
                    :default_url => "/assets/cd_default_:style.png"
                      
  #validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  has_attached_file :audio,
                    :url => "/system/audios/:id/:basename.:extension",
                    :path => ":rails_root/public/system/audios/:id/:basename.:extension"
  
  validates_attachment_size :audio, :less_than => 5.megabytes
  validates_attachment_content_type :audio, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3' , 'audio/mpg', 'audio/mpeg3', 'audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio', 'audio/x-m4a', 'audio/ogg']

  has_many :transactions, :through => :swap_provider
  has_many :transactions, :through => :swap_receiver
  
  validates_with DateOfReleaseValidator
end