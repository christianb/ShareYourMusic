class DateOfReleaseValidator < ActiveModel::Validator
  def validate(record)
    if record.year == nil
      return
    end
    
    if record.year > Time.now.year
      record.errors[:base] << "Erscheinungsjahr darf nicht in der Zukunft liegen."
    end
    
    if !((record.year >= (Time.now.year - 100)) && (record.year <= Time.now.year))
      record.errors[:base] << "Erscheinungsjahr muss zwischen "+(Time.now.year-100).to_s+" und "+Time.now.year.to_s+ " liegen"
    end
  end
end

class CompactDisk < ActiveRecord::Base
  attr_accessor :photo_url
  before_validation :download_remote_image, :if => :image_url_provided?
  #attr_accessible :user_id, :title, :artist, :genre, :description, :visible, :created_at, :updated_at, :photo_file_name, :photo_content_type, :photo_file_size, :audio_file_name, :audio_content_type, :audio_file_size, :year, :rank              
  
  #attr_accessible :photo_url
  
  
  has_many :songs, :dependent => :destroy, :inverse_of => :compact_disk
  accepts_nested_attributes_for :songs, :reject_if => proc { |attributes| attributes[:title].blank? }, :allow_destroy => true
  
  validates :title, :artist, :presence => true

  # each compact disk is assigned to exactly one 
  belongs_to :user
  validates_presence_of :user
        
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
   
   private

     def image_url_provided?
       !self.photo_url.blank?
     end

     def download_remote_image
       self.photo = do_download_remote_image
       self.photo_remote_url = photo_url
     end

     def do_download_remote_image
       io = open(URI.parse(photo_url))
       def io.original_filename; base_uri.path.split('/').last; end
       io.original_filename.blank? ? nil : io
     rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
     end 
end