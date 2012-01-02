require 'open-uri'

class User < ActiveRecord::Base
  attr_accessor :photo_url
  before_validation :download_remote_image, :if => :image_url_provided?
  validates_presence_of :photo_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'
  validates :firstname, :lastname, :email, :state, :presence => true  
  validates :email, :uniqueness => true
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  #validates :image_uri, :format => {:with => %r{\.(jpg|png)$}i, :allow_nil => true}
  
  # each user is assigned to exactly one role
  belongs_to :role
  
  # check if the role record referenced by the foreign key exist
  validates_presence_of :role
  has_many :compact_disks, :dependent => :destroy
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :photo, :alias, :email_notification, :search_own_cds, :photo_url
  
has_private_messages

has_attached_file :photo, :styles => { :normal => "150x150>", :small => "70x70>" },
                  :url  => "/system/users/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/system/users/:id/:style/:basename.:extension",
                  :default_url => "/assets/user_default.png"

#validates_attachment_presence :photo
validates_attachment_size :photo, :less_than => 5.megabytes
validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

# Constance for Admin and User Role ID
def self.admin  # Klassenmethode
  return 2
end

def self.user
  return 1
end

private

  def image_url_provided?
    !self.photo_url.blank?
    logger.debug "photo url blank? "+photo_url.blank?.to_s
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
