def field_to(field_name)
  case field_name
 
  when /Email/i
    :user_email
  when /Password/i
    :user_password
  when /Firstname/i
    :user_firstname
  when /Lastname/i
    :user_lastname
    #new_user_registration_path
  # Add more page name => path mappings here
 
  else
    raise "Can't find mapping from \"#{field_name}\" to a path."
  end
end