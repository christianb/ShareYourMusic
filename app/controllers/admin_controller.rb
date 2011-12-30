class AdminController < ApplicationController
  before_filter :isAdmin, :only =>[:show_all_users]
  
  def self.isAdmin(current_user)
      logger.debug "current user role id = "+current_user.role_id.to_s
      if (current_user.role_id == User.admin)
        logger.debug "isAdmin!!!"
        return true
      else
        logger.debug "is User!!!"
        return false
      end
  end
  
  def delete_cd
  end
  
  def delete_user
  end
  
  def manage_users
    @users = User.where(User.arel_table[:id].not_eq(current_user.id)).paginate(:page => params[:page], :per_page => 8)
    #@users = @users.delete_if {|u| u.id == current_user.id}
  end
  
  def manage_cds
    @cds = CompactDisk.where(CompactDisk.arel_table[:user_id].not_eq(current_user.id)).paginate(:page => params[:page], :per_page => 8)
    #@cds = @cds.delete_if {|cd| cd.user_id == current_user.id}
  end
  
  def destroy
    redirect_to welcome_path
  end
end
