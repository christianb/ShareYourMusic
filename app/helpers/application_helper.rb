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
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')", :remote => true)

  end

end
