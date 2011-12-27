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
  
  def manage_users
    @users = User.paginate(:page => params[:page], :per_page => 8)
    @users = @users.delete_if {|u| u.id == current_user.id}
  end
  
  def destroy
    redirect_to welcome_path
  end
end
