module TransactionHelper
  def getWantedCDs(cds)
    cd_array = cds.split(';')
    return cd_array[0].split(',')
  end
  
  def getMineCDs(cds)    
      cd_array = cds.split(';')
      return cd_array[1].split(',')
  end
  
  def getCover(cd)
    disk = CompactDisk.find(cd.to_i)
    return disk
  end
  
  def getOldReqMine(cds)
    cd_array = cds.split(';')
    return cd_array[0].split(',')
  end
  
  def getOldReqProvide(cds)
    cd_array = cds.split(';')
    return cd_array[1].split(',')
  end

  def getNewReqMine(cds)
    cd_array = cds.split(';')
    return cd_array[2].split(',')
  end
  
  def getNewReqProvide(cds)
    cd_array = cds.split(';')
    return cd_array[3].split(',')
  end
  
  def isRejected?(msg_id)
    status_rejected = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "%Abgelehnt; #{msg_id}%"])
    return !status_rejected.empty?
  end
  
  def getRejectedMsg(msg_id)
    status_rejected = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "%Abgelehnt; #{msg_id}%"])
    return status_rejected[0]
  end

  def isModified?(msg_id)
    status_modified = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "%Modifikation; #{msg_id}%"])
    return !status_modified.empty?
  end
end
