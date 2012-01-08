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
  before_create :randomize_file_name 
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
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png'], :message => "Der Content Type muss image/jpeg oder image/png sein. Evtl ist die Cover URL von MusicBrainz ungueltig!"
  
  has_attached_file :audio,
                    :url => "/system/audios/:id/:normalized_audio_file_name",
                    :path => ":rails_root/public/system/audios/:id/:normalized_audio_file_name"
  
  validates_attachment_size :audio, :less_than => 5.megabytes
  validates_attachment_content_type :audio, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3' , 'audio/mpg', 'audio/mpeg3', 'audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio', 'audio/x-m4a', 'audio/ogg', 'video/ogg', 'audio/mp4']

    Paperclip.interpolates :normalized_audio_file_name do |attachment, style|
      attachment.instance.normalized_audio_file_name
    end

    def normalized_audio_file_name
      #logger.debug "call normalize_audio_file"
      "#{self.audio_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
    end

  has_many :transactions, :through => :swap_provider
  has_many :transactions, :through => :swap_receiver
  
  validates_with DateOfReleaseValidator
  
  def randomize_file_name 
    #self.audio_file_name = "test.ogg"
    #logger.debug "path: "+self.audio.path
  end
  
  def convert_to_ogg
    #logger.debug "convert to ogg, with basename: #{File.basename(self.audio_file_name, File.extname(self.audio_fi).downcase)}"
    #logger.debug "convert path: #{self.audio.path} tp "
    
    if (!self.audio_file_name.nil?)
      cd = CompactDisk.find(self.id)
      path = cd.audio.path
      
      
      audio_file_name = cd.audio_file_name
      audio_content_type = cd.audio_content_type
      logger.debug "audio_content_type: "+audio_content_type
      
      
        filename = File.basename(cd.audio_file_name, File.extname(audio_file_name).downcase)
        filename = filename.gsub( /[^a-zA-Z0-9_\.]/, '_')
      
      current_filename = File.basename(self.audio_file_name, File.extname(self.audio_file_name).downcase)
      current_filename = current_filename.gsub( /[^a-zA-Z0-9_\.]/, '_')
      
      if cd.last_audio_file_name == current_filename
        logger.debug "song is same as last one"
        cd.last_audio_file_name = nil
        cd.save
      else
        logger.debug "song is not same as last one"
        logger.debug "cd.last_audio_file_name: "+cd.last_audio_file_name.to_s
        logger.debug "current_filename: "+current_filename
      end
      
      Resque.enqueue(AudioConverter, path, audio_file_name, audio_content_type, filename, cd.last_audio_file_name)
      
      #filename_with_ext = audio_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')
      
      #complete_path = path
      #path = path.chomp(filename_with_ext)
      #file_to_delete = path+cd.last_audio_file_name
      #logger.debug "file to delete: "+file_to_delete+".mp3"
      
      cd.audio_file_name = filename+".ogg"
      cd.audio_content_type = "audio/ogg"
      cd.last_audio_file_name = filename
      cd.save
      
=begin
      map = {
        :path => self.audio.path
        :audio_file_name => self.audio_file_name
        :audio_content_type
      }
      
      path = self.audio.path
      filename = File.basename(self.audio_file_name, File.extname(self.audio_file_name).downcase)
      filename = filename.gsub( /[^a-zA-Z0-9_\.]/, '_')
      filename_with_ext = self.audio_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')
      path = path.chomp(filename_with_ext)
      
      logger.debug "path: "+path
      logger.debug "self.audio.path = "+self.audio.path
      logger.debug "filename: "+filename
      logger.debug "filename_with_ext: "+filename_with_ext
      
      
      # wenn nicht ogg, dann erstelle ogg
      if (self.audio_content_type != "audio/ogg")
        system("ffmpeg -i #{self.audio.path} -b 1500k -vcodec libtheora -acodec libvorbis -ab 160000 -g 30 -y #{path+filename}.ogg")
        # entferne alte datei
      end
      
      # wenn nicht mp3 dann erstelle mp3
      if (self.audio_content_type != "audio/mp3")
        logger.debug "convert to mp3: ffmpeg -i #{self.audio.path} -vn -ar 44100 -ac 2 -ab 192 -y -f mp3 #{path+filename}.mp3"
        system("ffmpeg -i #{self.audio.path} -vn -ar 44100 -ac 2 -ab 192 -y -f mp3 #{path+filename}.mp3")
        
        
      end
      
      if (self.audio_content_type != "audio/ogg" && self.audio_content_type != "audio/mp3")
        system("rm #{self.audio.path}")
      end
      
      self.audio_file_name = filename+".ogg"
      self.audio_content_type = "audio/ogg"
      self.save
=end
    end
    
    #File.expand_path("")
    #system("ffmpeg -i #{self.audio.path} -b 1500k -vcodec libtheora -acodec libvorbis -ab 160000 -g 30 #{self.audio.path}.ogg")
  end
  
  def convert_tempfile(tempfile)
    #cmd_args = [File.expand_path(tempfile.path), File.expand_path(dst.path)]
    #logger.debug "call convert_tempfile: #{self.audio_file_name} in path #{self.audio.path}"
    #system("ffmpeg -i #{self.audio_file_name} -b 1500k -vcodec libtheora -acodec libvorbis -ab 160000 -g 30 test.ogg")
  end
   
   private

     def image_url_provided?
       !self.photo_url.blank?
     end

     def download_remote_image
       logger.debug "call download remote image"
       self.photo = do_download_remote_image
       self.photo_remote_url = photo_url
       
       if self.photo_content_type == 'image/gif'
        logger.debug "remote photo content_type"+self.photo_content_type
        self.photo_url = "/assets/cd_default_:style.png"
        self.photo = do_download_remote_image
        self.photo_remote_url = photo_url
       end
     end

     def do_download_remote_image
       io = open(URI.parse(photo_url))
       def io.original_filename; base_uri.path.split('/').last; end
       io.original_filename.blank? ? nil : io
     rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
     end 
     
     

       def convert_video_to_flv
         logger.debug "currently trying to convert the video ( #{@file} ) from content type of test.ogg to flv"
         # system "ffmpeg -i #{full_filename} -ar 22050 -ab 32 -y -f flv -s 320x240 #{full_filename}.flv"
         #system "ffmpeg -i #{full_filename} -r 25 -acodec mp3 -ar 22050 -y -s 320x240 #{full_filename}.flv"
         # system "flvtool2 -U #{full_filename}"
       end
end