class AdminController < ApplicationController
  
  def delete_cd
  end
  
  def delete_user
  end
  
  def show_all_users
    @users = User.all
  end
  
end
