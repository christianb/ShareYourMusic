def path_to(page_name)
  case page_name
 
  when /Welcome/i
    welcome_path
  when /Register/i
    new_user_registration_path
  when /Logout/i
    destroy_user_session_path
  when "Edit registration"
    edit_user_registration_path
  when "Profil"
    user = User.where(:email => "christianb@web.de")
    @user = user[0]
    user_path(@user)
  when "Account loeschen"
    url_for(:action => "destroy", :controller => "devise/registrations")
  when "Alle CDs"
    compact_disk_index_path
  when "Neueste CDs"
    latest_cd_path
  when "Aktivste Benutzer"
    most_active_user_path
  when "Tollste CDs"
    best_cd_path
    #
    #url_for(:action => "show", :controller => "user")
    
  # Add more page name => path mappings here
 
  else
    raise "Can't find mapping from \"#{page_name}\" to a path."
  end
end