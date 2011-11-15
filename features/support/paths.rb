def path_to(page_name)
  case page_name
 
  when /Welcome/i
    root_path
  when /Register/i
    new_user_registration_path
  when "Sign up"
    
  # Add more page name => path mappings here
 
  else
    raise "Can't find mapping from \"#{page_name}\" to a path."
  end
end