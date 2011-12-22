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
  def getSongs(cd)
    logger.debug "cd title: "+cd.title
    logger.debug "songs:"
    songs_array = Song.where(:compact_disk_id => cd.id)
    if (!songs_array.empty?)
      index = 1;
      #logger.debug songs_array
      #logger.debug "length: "+songs_array.size.to_s
      #logger.debug "song id: "+songs_array[0].id.to_s
      #logger.debug "song title: "+songs_array[0].title
      #logger.debug "songs array: "+songs_array
      string = ""
      songs_array.each do |s|
        #logger.debug "#title: "+s.title
        string += index.to_s + ". " + s.title + "<br>"
        index += 1
      end
      return string
    end
    return ""
  end
end
