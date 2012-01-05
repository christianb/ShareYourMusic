module CompactDiskHelper
  def existingTransactions(cd_id, user_id)
    user = User.find(user_id)
    cd = CompactDisk.find(cd_id)
    
    sent = user.sent_messages.find(:all, :conditions => ["subject LIKE '%?%'", cd])
    received = user.received_messages.find(:all, :conditions => ["subject LIKE '%?%'", cd])
    @sended = false
    @rvd = false
    
    sent.each do |s|
      cd_array = s.subject.split(';')
      split_array = cd_array[0].split(',')
      if (cd_array.include?(cd_id.to_s))
        @sended = true
        break
      end
    end
    
    received.each do |s|
      cd_array = s.subject.split(';')
      split_array = cd_array[0].split(',')
      if(cd_array.include?(cd_id.to_s))
        @rvd = true
        break
      end
    end
    
    return (@sended || @rvd)
  end
end
