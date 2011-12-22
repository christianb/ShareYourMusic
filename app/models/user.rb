class User < ActiveRecord::Base
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
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :photo, :alias
  
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
  
end
