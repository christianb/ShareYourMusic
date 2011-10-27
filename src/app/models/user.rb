class User < ActiveRecord::Base
  validates :firstname, :lastname, :email, :password, :state, :presence => true  
  validates :email, :uniqueness => true
end
