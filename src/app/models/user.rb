class User < ActiveRecord::Base
  validates :firstname, :lastname, :email, :state, :presence => true  
  validates :email, :uniqueness => true
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates :image_uri, :format => {:with => %r{\.(jpg|png)$}i}
  
  # each user is assigned to exactly one role
  belongs_to :role
  
  # check if the role record referenced by the foreign key exist
  validates_presence_of :role
  has_many :compact_disks
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :image_uri
  
has_private_messages
  
end
