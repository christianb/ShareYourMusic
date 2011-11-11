class Role < ActiveRecord::Base
  validates :role, :presence => true
  validates :role, :uniqueness => true
  
  has_many :users
  
end
