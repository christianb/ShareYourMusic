module ApplicationHelper
  def getUnreadMessageCount(id)
    u = User.find_by_id(id)
    #u.received_messages
    messages = u.received_messages.find(:all, :conditions => ["body LIKE ? OR body LIKE ?", "%Anfrage%", "%Modifikation%"])
    return messages.size
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_partial", :f => builder)
    end
  #  link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')", :remote => true, :class => "addFieldBt")

  end
  
  def inTransaction?(user, cd_id)
    in_transaction = false
    
    sent_msg = user.sent_messages(:all)
    received_msg = user.received_messages(:all)
        
    sent_msg.each do |sm|
      if sm.subject.include?(cd_id.to_s)
        in_transaction = true
        break
      end
    end
    
    received_msg.each do |rm|
      if rm.subject.include?(cd_id.to_s)
        in_transaction = true
        break
      end
    end
    return in_transaction
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
