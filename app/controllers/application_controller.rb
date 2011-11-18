class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def after_sign_in_path_for(resource)
      stored_location_for(resource) || compact_disk_index_path
  end
  
  def after_update_path_for(resource)
    user_path(current_user)
  end
  
  def after_sign_out_path_for(resource_or_scope)
    welcome_path
  end
end
