module ApplicationHelper
  def getUnreadMessageCount(id)
    u = User.find_by_id(id)
    u.received_messages
    return u.unread_message_count
  end
end
