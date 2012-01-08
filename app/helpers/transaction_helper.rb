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
  
  def getCD(cd)
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
    status_rejected = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "Abgelehnt; #{msg_id}%"])
    return !status_rejected.empty?
  end
  
  def getRejectedMsg(msg_id)
    status_rejected = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "Abgelehnt; #{msg_id}%"])
    return status_rejected[0]
  end

  def getAcceptedMsg(msg_id)
     status_accepted = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "Angenommen; #{msg_id}%"])
     return status_accepted[0]
   end

  def getModifiedMsg(msg_id)
     status_modified= current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "Modifiziert; #{msg_id}%"])
     return status_modified[0]
   end

  def isModified?(msg_id)
    status_modified = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "Modifikation; #{msg_id}%"])
    return !status_modified.empty?
  end
  
  def isAccepted?(msg_id)
    status_modified = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "Angenommen; #{msg_id}%"])
    return !status_modified.empty?
  end
  
  def isModAccepted?(msg_id)
     status_modAccepted = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "MAngenommen; #{msg_id}%"])
      return !status_modAccepted.empty?
  end

  def isModRejected?(msg_id)
     status_modAccepted = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "MAbgelehnt; #{msg_id}%"])
      return !status_modAccepted.empty?
  end
  
  def getModifiedMsg(msg_id)
     status_modified_accepted= current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "MAngenommen; #{msg_id}%"])
     return status_modified_accepted[0]
  end
  
  def getModRejectedMsg(msg_id)
    status_rejected = current_user.received_messages.find(:all, :conditions => ["body LIKE ?", "MAbgelehnt; #{msg_id}%"])
    return status_rejected[0]
  end
  
  def getDiskById(cd_id)
    cd = CompactDisk.find(cd_id)
    return cd
  end
end
