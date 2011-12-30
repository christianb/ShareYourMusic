module ApplicationHelper
  def getUnreadMessageCount(id)
    u = User.find_by_id(id)
    #u.received_messages
    messages = u.received_messages.find(:all, :conditions => ["body LIKE ? OR body LIKE ?", "%Anfrage%", "%Modifikation%"])
    return messages.size
  end
end
