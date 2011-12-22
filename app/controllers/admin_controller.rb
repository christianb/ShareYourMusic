class AdminController < ApplicationController
  before_filter :isAdmin, :only =>[:show_all_users]
  
  def isAdmin
    logger.debug "current user role id = "+current_user.role_id.to_s
    if (current_user.role_id == User.admin)
      logger.debug "isAdmin!!!"
      return true
    else
      logger.debug "is User!!!"
      redirect_to :back
    end
  end
  
  def delete_cd
  end
  
  def delete_user
  end
  
  def show_all_users
    @users = User.all
  end
  
end
