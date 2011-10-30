class User < ActiveRecord::Base
  validates :firstname, :lastname, :email, :password, :state, :presence => true  
  validates :email, :uniqueness => true
  validates :email, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates :image_uri, :format => {:with => %r{\.(jpg|png)$}i}
end
