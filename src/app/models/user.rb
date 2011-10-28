class User < ActiveRecord::Base
  validates :firstname, :lastname, :email, :password, :state, :presence => true  
  validates :email, :uniqueness => true
  validates :image_uri, :format => {:with => %r{\.(jpg|png)$}i}
end
