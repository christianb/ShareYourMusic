class UserIDsValidator < ActiveModel::Validator
  def validate(record)
    if record.provider_id == record.receiver_id
      record.errors[:base] << "same id of provider and receiver is not allowed"
    end
  end
end

class UserPresenceValidator < ActiveModel::Validator
  def validate(record)
    user = User.where(:id => record.provider_id).first
    if user.nil?
      record.errors[:base] << "Provider id does not exist"
    end
    
    user = User.where(:id => record.receiver_id).first
    if user.nil?
      record.errors[:base] << "Reiceiver id does not exist"
    end
  end
end

class Transaction < ActiveRecord::Base
  belongs_to :user, :class_name => "User", :foreign_key => "provider_id"
  belongs_to :user, :class_name => "User", :foreign_key => "receiver_id"
  
  validates_with UserIDsValidator
  validates_with UserPresenceValidator
  
end




