class SameForeignKeyValidator < ActiveModel::Validator
  def validate(record)
    if record.provider_id == record.receiver_id
      record.errors[:base] << "same id of provider and receiver is not allowed"
    end
    
    if record.provider_disk_id == record.receiver_disk_id
      record.errors[:base] << "same disk_id of provider and receiver is not allowed"
    end
  end
end

class ForeignKeyPresenceValidator < ActiveModel::Validator
  def validate(record)
    user = User.where(:id => record.provider_id).first
    if user.nil?
      record.errors[:base] << "Provider id does not exist"
    end
    
    user = User.where(:id => record.receiver_id).first
    if user.nil?
      record.errors[:base] << "Reiceiver id does not exist"
    end
    
    disk = CompactDisk.where(:id => record.provider_disk_id).first
    if disk.nil?
      record.errors[:base] << "provider_disk_id does not exist"
    end
    
    disk = CompactDisk.where(:id => record.receiver_disk_id).first
    if disk.nil?
      record.errors[:base] << "reiceiver_disk_id does not exist"
    end
  end
end

class Transaction < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => "provider_id"
  belongs_to :user, :class_name => "User", :foreign_key => "receiver_id"
  
  belongs_to :compact_disk, :class_name => "CompactDisk", :foreign_key => "provider_disk_id"
  belongs_to :compact_disk, :class_name => "CompactDisk", :foreign_key => "receiver_disk_id"
  
  validates_with SameForeignKeyValidator
  validates_with ForeignKeyPresenceValidator
  
  has_many :compact_disks, :through => :swap_provider
  has_many :compact_disks, :through => :swap_receiver
end




