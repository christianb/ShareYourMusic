def field_to(field_name)
  case field_name
 
  when "Email"
    'user_email'
  #when /LoginEmail/i
  #  :user_email
  #when /LoginPassword/i
  #  :user_password
  when "Password"
    'user_password'
  when "Password confirmation"
    'user_password_confirmation'
  when "Firstname"
    'user_firstname'
  when "Lastname"
    'user_lastname'
  when "Image"
    'user_image_uri'
    #new_user_registration_path
  # Add more page name => path mappings here
 
  else
    raise "Can't find mapping from \"#{field_name}\" to a path."
  end
end